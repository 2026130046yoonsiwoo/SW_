$html = [System.IO.File]::ReadAllText("index.html", [System.Text.Encoding]::UTF8)

# Find the MUSICALS_DATA block
$startIdx = $html.IndexOf("const MUSICALS_DATA = [")
$endIdx = $html.IndexOf("];", $startIdx)
$jsData = $html.Substring($startIdx, $endIdx - $startIdx + 2)

# Use regex to find all objects
$pattern = '(?ms)\{\s*id:\s*"([^"]+)",\s*title:\s*"([^"]+)"(.*?)\}(?=\s*,\s*\{|\s*\])'
$matches = [regex]::Matches($jsData, $pattern)

$musicals = @()
foreach ($m in $matches) {
    $id = $m.Groups[1].Value
    $title = $m.Groups[2].Value
    $body = $m.Groups[3].Value
    
    $startDate = ""
    if ($body -match 'startDate:\s*"([^"]+)"') {
        $startDate = $Matches[1]
    }
    
    $endDate = ""
    if ($body -match 'endDate:\s*"([^"]+)"') {
        $endDate = $Matches[1]
    }
    
    $theaters = ""
    if ($body -match 'theaters:\s*\[([^\]]+)\]') {
        $theaters = $Matches[1].Replace('"', '').Trim()
    }
    
    $musicals += [PSCustomObject]@{
        id = $id
        title = $title
        startDate = $startDate
        endDate = $endDate
        theaters = $theaters
    }
}

$musicals | ConvertTo-Json -Depth 3 | Out-File "musicals_list.json" -Encoding utf8
Write-Host "Extracted $($musicals.Count) musicals to musicals_list.json"
