$html = [System.IO.File]::ReadAllLines("index.html", [System.Text.Encoding]::UTF8)
for ($i = 0; $i -lt $html.Length; $i++) {
    if ($html[$i] -match "개월") {
        Write-Host "Line $($i + 1): $($html[$i].Trim())"
    }
}
