$zipFolder = Get-Location | Select-Object -ExpandProperty Path
$outputFolder = Get-Location | Select-Object -ExpandProperty Path

$7zip = ((Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | ?{$_.DisplayName -like "7-Zip*"}).InstallLocation + "7z.exe")

if ($null -eq $7zip) {
    Write-Host "Error: 7-Zip executable not found. Please make sure it is installed and accessible." -ForegroundColor Red
    Exit
}

# Check if output folder exists, create if not
if (!(Test-Path -Path $outputFolder -PathType Container)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

# Extract 7z files
$zipFiles = Get-ChildItem -Recurse -Filter *.7z

if ($zipFiles.Count -eq 0) {
    Write-Host "No 7z files found in '$zipFolder'." -ForegroundColor Yellow
    Exit
}

foreach ($zipFile in $zipFiles) {
    $outputSubfolder = Join-Path -Path $outputFolder -ChildPath $zipFile.BaseName

    if (Test-Path -Path $outputSubfolder -PathType Container) {
        Write-Host "Skipping extraction of '$zipFile'. Output subfolder '$outputSubfolder' already exists." -ForegroundColor Yellow
        Continue
    }

    $command = "& `"$7zip`" x `"$zipFile`" -o`"$outputSubfolder`" 2>&1"
    $output = Invoke-Expression $command

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error extracting '$zipFile'. Error: $output" -ForegroundColor Red
    } else {
        Write-Host "Successfully extracted '$zipFile' to '$outputSubfolder'." -ForegroundColor Green
    }
}
