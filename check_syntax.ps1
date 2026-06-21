$html = [System.IO.File]::ReadAllText("index.html", [System.Text.Encoding]::UTF8)
$startIdx = $html.IndexOf("<script>")
$endIdx = $html.LastIndexOf("</script>")

if ($startIdx -eq -1 -or $endIdx -eq -1) {
    Write-Host "No script tag found!"
    exit 1
}

$js = $html.Substring($startIdx + 8, $endIdx - ($startIdx + 8))
[System.IO.File]::WriteAllText("temp.js", $js, [System.Text.Encoding]::UTF8)
Write-Host "JS extracted to temp.js"

$stack = New-Object System.Collections.Generic.List[PSObject]
$lines = $js -split "`n"
$hasMismatches = $false

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    for ($j = 0; $j -lt $line.Length; $j++) {
        $char = $line[$j]
        if ($char -eq '{' -or $char -eq '[' -or $char -eq '(') {
            $stack.Add((New-Object PSObject -Property @{ char = $char; line = $i + 1 }))
        } elseif ($char -eq '}' -or $char -eq ']' -or $char -eq ')') {
            if ($stack.Count -eq 0) {
                Write-Host "Extra closing char '$char' at line $($i + 1)"
                $hasMismatches = $true
            } else {
                $top = $stack[$stack.Count - 1]
                $stack.RemoveAt($stack.Count - 1)
                if (($char -eq '}' -and $top.char -ne '{') -or
                    ($char -eq ']' -and $top.char -ne '[') -or
                    ($char -eq ')' -and $top.char -ne '(')) {
                    Write-Host "Mismatched '$($top.char)' (line $($top.line)) and '$char' (line $($i + 1))"
                    $hasMismatches = $true
                }
            }
        }
    }
}

if ($stack.Count -gt 0) {
    Write-Host "Unclosed brackets:"
    for ($k = 0; $k -lt [Math]::Min($stack.Count, 10); $k++) {
        $item = $stack[$k]
        Write-Host "  '$($item.char)' at line $($item.line)"
    }
    $hasMismatches = $true
}

if (-not $hasMismatches) {
    Write-Host "Brackets balance: OK"
} else {
    Write-Host "Brackets balance: FAILED"
}
