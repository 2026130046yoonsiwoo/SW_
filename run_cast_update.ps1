$content = [System.IO.File]::ReadAllText("add_cast.ps1", [System.Text.Encoding]::UTF8)
$utf8bom = New-Object System.Text.UTF8Encoding($true)
[System.IO.File]::WriteAllText("add_cast.ps1", $content, $utf8bom)
Write-Host "Converted add_cast.ps1 to UTF-8 with BOM"

# Run it
powershell -ExecutionPolicy Bypass -File .\add_cast.ps1
