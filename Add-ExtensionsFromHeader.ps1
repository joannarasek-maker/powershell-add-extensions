param(
    [string]$Path = ".",
    [switch]$Recurse
)

# Get all files in the target path that do NOT contain a dot in the name
$files = Get-ChildItem -Path $Path -File -Recurse:$Recurse |
         Where-Object { $_.Name -notlike "*.*" }

foreach ($file in $files) {
    # Read the first 12 bytes to detect the file type
    $bytes = Get-Content -Path $file.FullName -Encoding Byte -TotalCount 12

    if ($bytes.Length -lt 8) {
        Write-Host "File too small to detect type: $($file.FullName)"
        continue
    }

    $ext = $null

    # JPG – magic bytes: FF D8 FF
    if ($bytes[0] -eq 0xFF -and $bytes[1] -eq 0xD8 -and $bytes[2] -eq 0xFF) {
        $ext = ".jpg"
    }
    # PNG – magic bytes: 89 50 4E 47
    elseif ($bytes[0] -eq 0x89 -and $bytes[1] -eq 0x50 -and
            $bytes[2] -eq 0x4E -and $bytes[3] -eq 0x47) {
        $ext = ".png"
    }
    # GIF – magic bytes: 47 49 46 ("GIF")
    elseif ($bytes[0] -eq 0x47 -and $bytes[1] -eq 0x49 -and $bytes[2] -eq 0x46) {
        $ext = ".gif"
    }
    # MP4 – bytes 4–7 contain the string "ftyp"
    elseif ($bytes[4] -eq 0x66 -and $bytes[5] -eq 0x74 -and
            $bytes[6] -eq 0x79 -and $bytes[7] -eq 0x70) {
        $ext = ".mp4"
    }

    if ($ext) {
        $newName = $file.Name + $ext
        Rename-Item -Path $file.FullName -NewName $newName
        Write-Host "Renamed: $($file.Name) -> $newName"
    }
    else {
        Write-Host "Unknown file type (no extension added): $($file.FullName)"
    }
}
