$content = [System.IO.File]::ReadAllText("update_musicals.ps1", [System.Text.Encoding]::UTF8)
$utf8bom = New-Object System.Text.UTF8Encoding($true)
[System.IO.File]::WriteAllText("update_musicals.ps1", $content, $utf8bom)
Write-Host "Converted update_musicals.ps1 to UTF-8 with BOM"

# Run it
powershell -ExecutionPolicy Bypass -File .\update_musicals.ps1
