# Sevun-Zip: PowerShell 7-Zip File Extractor

Sevun-Zip is a small PowerShell tool that makes it easy to extract multiple 7z files within a specific directory

## Features

- Automated detection and extraction of 7z files within a directory
- Checks for existing extracted folders to avoid re-extraction
- Extracts into each file's respective folder
- Locates 7-Zip installation using registry keys

<br>

## Prerequisites

### Linux

> - any distribution or flavor with PowerShell 7.0 installed 
>   - https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.3 
> - p7zip installed and in the system PATH
>   - Ubuntu Example
>     ```bash
>     sudo apt-get install p7zip-full

### Windows

> - Windows 7 or later
> - 7-Zip software installed
>   - https://www.7-zip.org/download.html
> - PowerShell 5.0 or later 
>   - PowerShell 7.0 is highly recommended but not required 

<br>

## Installation & Usage

No installation is required for this script. Clone the repository into a target directory with your zipped files and run the PowerShell script (.ps1 file) from within that directory. The script will automatically extract all the supported compressed files into their respective folders. Unless the -unpack argument is used

```powershell
.\sevun-zip.ps1
```

<br>

## Command-line Options

The script supports two **optional** command-line arguments which provide additional functionality:

> `-unpack`  :  extracts all files into the root of the directory instead of seperate folders
> 
> `-delete`  :  **deletes** the original file once it has been successfully extracted

<br>

