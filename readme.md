# Sevun-Zip: PowerShell 7-Zip File Extractor

Sevun-Zip is a small PowerShell tool that makes it easy to extract 7z files within a specific directory. The script scans a directory for any 7z files, and if found, it automatically extracts them into their respective folders. The script utilizes the 7-Zip software, thus it should be installed and accessible on your machine for the script to work.

## Features

- Automated detection and extraction of 7z files within a directory
- Checks for existing extracted folders to avoid re-extraction
- Extracts into each file's respective folder
- Locates 7-Zip installation using registry keys

## Pre-requisites

1. Windows 7 or later
2. 7-Zip software installed
3. PowerShell 5.0 or later

## Installation

No installation is required for this script. Simply copy the script into a PowerShell (sevun-zip.ps1) file and run it

## Command Line Arguments

The script supports two **optional** command-line arguments which provide additional functionality:

- `-unpack` : Extracts all the files into a single folder instead of their respective folders
- `-delete` : Deletes the original .7z file once it has been successfully extracted

### How to use arguments

You can use these arguments by including them when running the script from your PowerShell console. Here is an example of using the `--unpack` and `--delete` arguments:

## Usage

Navigate to the directory where you have your .7z files and where you want the files to be extracted. Run the PowerShell script (.ps1 file) from that directory. The script will automatically extract all the .7z files into their respective folders

```powershell
.\sevun-zip.ps1
