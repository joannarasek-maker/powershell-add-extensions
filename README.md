# powershell-add-extensions
PowerShell script to add media extensions (JPG/PNG/GIF/MP4) based on file headers
## Overview

This repository contains a PowerShell script that adds file extensions
to media files that were recovered or exported **without extensions**.

Supported formats:
- `.jpg`
- `.png`
- `.gif`
- `.mp4`

The script reads the first bytes of each file (magic number / header)
and appends the correct extension. It does *not* convert files between
formats.

## Usage

1. Download `Add-ExtensionsFromHeader.ps1` to a folder on your machine.
2. Open PowerShell in the folder that contains the files:
   ```powershell
   cd "C:\Path\To\Your\Folder"
3. Run the script:
   .\Add-ExtensionsFromHeader.ps1
4. Optionally, process another folder or include subfolders:
   .\Add-ExtensionsFromHeader.ps1 -Path "C:\Some\Folder"
   .\Add-ExtensionsFromHeader.ps1 -Path "C:\Some\Folder" -Recurse
