# Sevun-Zip: PowerShell 7-Zip File Extractor

Sevun-Zip is a small PowerShell tool that makes it easy to extract multiple 7z files within a specific directory. The script scans a directory for any 7z files, and if found, automatically extracts them into their respective folders. The script utilizes the 7-Zip software, thus it should be installed and accessible on your machine for the script to work.

## Features

- Automated detection and extraction of 7z files within a directory
- Checks for existing extracted folders to avoid re-extraction
- Extracts into each file's respective folder
- Locates 7-Zip installation using registry keys

## Pre-requisites

* Windows 7 or later
* 7-Zip software installed
* PowerShell 5.0 or later

## Installation

No installation is required for this script. Clone the repository into a target directory and run the PowerShell script (sevun-zip.ps1)

## Command Line Arguments

The script supports two **optional** command-line arguments which provide additional functionality:

- `-unpack`  :  extracts all the files into a single folder instead of their respective folders
- `-delete`  :  deletes the original .7z file once it has been successfully extracted

## Usage

Navigate to the directory where you have your .7z files and where you want the files to be extracted. Run the PowerShell script (.ps1 file) from that directory. The script will automatically extract all the .7z files into their respective folders

```powershell
.\sevun-zip.ps1
```
