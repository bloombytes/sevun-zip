param(
    [switch]$unpack,
    [switch]$delete
)

Function Test-IsWindows {
    return $PSVersionTable.Platform -eq "Win32NT"
}

$zipFolder = Get-Location | Select-Object -ExpandProperty Path
$outputFolder = Get-Location | Select-Object -ExpandProperty Path
$logFile = Join-Path -Path $outputFolder -ChildPath "sevun-zip.log"

if (Test-IsWindows) {
    try {
        $7zip = ((Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | ?{$_.DisplayName -like "7-Zip*"}).InstallLocation + "7z.exe")
    } catch {
        Write-Host "!! error accessing the registry to retrieve 7-Zip location: $_ !!" -ForegroundColor Red
        "!! error accessing the registry to retrieve 7-Zip location: $_ !!" | Add-Content $logFile
        Exit
    }
} else {
    # Assume p7zip is in PATH for Linux
    $7zip = "7z"
}

if (!(Test-Path -Path $7zip)) {
    Write-Host "!! 7-Zip executable not found. please make sure it is installed and accessible !!" -ForegroundColor Red
    "!! 7-Zip executable not found. please make sure it is installed and accessible !!" | Add-Content $logFile
    Exit
}

try {
    if (!(Test-Path -Path $outputFolder -PathType Container)) {
        New-Item -ItemType Directory -Path $outputFolder | Out-Null
    }
}
catch {
    Write-Host "!! error creating output directory '$outputFolder': $_ !!" -ForegroundColor Red
    "!! error creating output directory '$outputFolder': $_ !!" | Add-Content $logFile
    Exit
}

$zipFiles = Get-ChildItem -Recurse -Include *.7z, *.zip, *.rar, *.tar, *.gz, *.tgz, *.bz2, *.tbz, *.tbz2, *.xz, *.iso, *.arj, *.lzh, *.cab, *.Z, *.cpio, *.rpm, *.deb, *.dmg, *.wim, *.swm, *.vhd, *.vdi, *.vmdk, *.udf

if ($zipFiles.Count -eq 0) {
    Write-Host "!! no 7z or zip files found in '$zipFolder' !!" -ForegroundColor Yellow
    "!! no 7z or zip files found in '$zipFolder' !!" | Add-Content $logFile
    Exit
}

foreach ($zipFile in $zipFiles) {
    if($unpack) {
        $outputSubfolder = $outputFolder
    } else {
        $outputSubfolder = Join-Path -Path $outputFolder -ChildPath $zipFile.BaseName
        if (Test-Path -Path $outputSubfolder -PathType Container) {
            Write-Host "# skipped extraction of '$zipFile', output subfolder '$outputSubfolder' already exists #" -ForegroundColor Yellow
            "# skipped extraction of '$zipFile', output subfolder '$outputSubfolder' already exists #" | Add-Content $logFile
            Continue
        }
    }

    $tempLogFile = Join-Path -Path $outputFolder -ChildPath "sevun-zip.temp"
    Write-Host "...starting '$zipFile' extract <3" -ForegroundColor DarkMagenta
    $exitCode = -1
    $retryCount = 0

    do {
        $retryCount++
        Start-Process -FilePath $7zip -ArgumentList "x `"$zipFile`" -o`"$outputSubfolder`" -y" -NoNewWindow -Wait -RedirectStandardOutput $tempLogFile
        $exitCode = $LASTEXITCODE

        if ($exitCode -ne 0) {
            Write-Host "!! failed to extract '$zipFile', retrying... (attempt: $retryCount)" -ForegroundColor Red
            "!! failed to extract '$zipFile', retrying... (attempt: $retryCount)" | Add-Content $logFile
            Start-Sleep -Seconds 10
        }
    } while ($exitCode -ne 0 -and $retryCount -lt 3)

    $output = Get-Content -Path $tempLogFile
    Remove-Item -Path $tempLogFile

    if ($exitCode -eq 0) {
        $output | Add-Content $logFile    
        Write-Host "+ extracted '$zipFile'" -ForegroundColor Green
        "+ extracted '$zipFile'" | Add-Content $logFile
    } else {
        Write-Host "!! failed to extract '$zipFile' after 3 attempts" -ForegroundColor Red
        "!! failed to extract '$zipFile' after 3 attempts" | Add-Content $logFile
    }

    if ($delete -and $exitCode -eq 0) {
        try {
            Remove-Item -Path $zipFile
            Write-Host "- removed '$zipFile'" -ForegroundColor DarkGray
            "- removed '$zipFile'" | Add-Content $logFile
        } catch {
            Write-Host "!! error deleting '$zipFile': $_ !!" -ForegroundColor Red
            "!! error deleting '$zipFile': $_ !!" | Add-Content $logFile
        }
    }
}
