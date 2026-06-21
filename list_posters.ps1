$html = [System.IO.File]::ReadAllText("index.html", [System.Text.Encoding]::UTF8)
$matches = [regex]::Matches($html, 'id:\s*"([^"]+)",\s*title:\s*"([^"]+)",(?:[^{}]+?)(?:poster:\s*"([^"]+)")')
foreach ($m in $matches) {
    Write-Host "ID: $($m.Groups[1].Value) | Title: $($m.Groups[2].Value) | Poster: $($m.Groups[3].Value)"
}
