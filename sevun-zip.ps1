param(
    [switch]$unpack,
    [switch]$delete
)

$zipFolder = Get-Location | Select-Object -ExpandProperty Path
$outputFolder = Get-Location | Select-Object -ExpandProperty Path
$logFile = Join-Path -Path $outputFolder -ChildPath "sevun-zip.log"

$7zip = ((Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | ?{$_.DisplayName -like "7-Zip*"}).InstallLocation + "7z.exe")
Write-Host "_.~~._.~~._.~~._ `n script go brrr `n ~~._.~~._.~~._.~~" -ForegroundColor DarkMagenta
if ($null -eq $7zip) {
    Write-Host "!! 7-Zip executable not found. please make sure it is installed and accessible !!" -ForegroundColor Red
    "!! 7-Zip executable not found. please make sure it is installed and accessible !!" | Add-Content $logFile
    Exit
}

if (!(Test-Path -Path $outputFolder -PathType Container)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

$zipFiles = Get-ChildItem -Recurse -Filter *.7z

if ($zipFiles.Count -eq 0) {
    Write-Host "No 7z files found in '$zipFolder'" -ForegroundColor Yellow
    "No 7z files found in '$zipFolder'" | Add-Content $logFile
    Exit
}

foreach ($zipFile in $zipFiles) {
    if($unpack) {
        $outputSubfolder = $outputFolder
    } else {
        $outputSubfolder = Join-Path -Path $outputFolder -ChildPath $zipFile.BaseName
        if (Test-Path -Path $outputSubfolder -PathType Container) {
            Write-Host "# skipped extraction of '$zipFile', output subfolder '$outputSubfolder' already exists" -ForegroundColor Yellow
            "# skipped extraction of '$zipFile', output subfolder '$outputSubfolder' already exists" | Add-Content $logFile
            Continue
        }
    }

    $tempLogFile = Join-Path -Path $outputFolder -ChildPath "sevun-zip.temp"
    Write-Host "...starting '$zipFile' extract <3" -ForegroundColor DarkMagenta
    Start-Process -FilePath $7zip -ArgumentList "x `"$zipFile`" -o`"$outputSubfolder`" -y" -NoNewWindow -Wait -RedirectStandardOutput $tempLogFile
    $output = Get-Content -Path $tempLogFile
    Remove-Item -Path $tempLogFile

    $output | Add-Content $logFile

    if ($LASTEXITCODE -eq 0) {
        Write-Host "+ extracted '$zipFile'" -ForegroundColor Green
        "+ extracted '$zipFile'" | Add-Content $logFile
        if ($delete) {
            Remove-Item -Path $zipFile -ErrorAction SilentlyContinue
            if (!$?) {
                Write-Host "Error deleting '$zipFile'" -ForegroundColor Red
                "!! error removing '$zipFile' !!" | Add-Content $logFile
            } else {
                Write-Host "- removed '$zipFile'" -ForegroundColor Green
                "- removed '$zipFile'" | Add-Content $logFile
            }
        }
    } else {
        Write-Host "error extracting '$zipFile', $output" -ForegroundColor Red
        "error extracting '$zipFile', $output" | Add-Content $logFile
    }
}
