$html = [System.IO.File]::ReadAllText("index.html", [System.Text.Encoding]::UTF8)

function Update-MusicalDatesAndTheaters($htmlText, $id, $start, $end, $theaters) {
    $searchToken = "id: `"$id`""
    $startIdx = $htmlText.IndexOf($searchToken)
    if ($startIdx -eq -1) {
        return $htmlText
    }
    
    $length = 1500
    if ($startIdx + $length -gt $htmlText.Length) {
        $length = $htmlText.Length - $startIdx
    }
    
    $block = $htmlText.Substring($startIdx, $length)
    $nextObjIdx = $block.IndexOf("id: `"", $searchToken.Length)
    if ($nextObjIdx -ne -1) {
        $block = $block.Substring(0, $nextObjIdx)
    }
    
    $newBlock = $block
    
    if ($start) {
        $newBlock = [regex]::Replace($newBlock, 'startDate:\s*"[^"]+"', "startDate: `"$start`"")
    }
    if ($end) {
        $newBlock = [regex]::Replace($newBlock, 'endDate:\s*"[^"]+"', "endDate: `"$end`"")
    }
    if ($theaters) {
        $formattedTheaters = @()
        foreach ($t in $theaters) {
            $formattedTheaters += "`"$t`""
        }
        $theatersStr = [string]::Join(", ", $formattedTheaters)
        $newBlock = [regex]::Replace($newBlock, 'theaters:\s*\[[^\]]+\]', "theaters: [$theatersStr]")
    }
    
    $htmlText = $htmlText.Replace($block, $newBlock)
    return $htmlText
}

$html = Update-MusicalDatesAndTheaters $html "wicked" "2025-11-20" "2026-01-18" @("드림씨어터")
$html = Update-MusicalDatesAndTheaters $html "phantom" "2026-12-15" "2027-02-28" @("블루스퀘어 우리은행홀")
$html = Update-MusicalDatesAndTheaters $html "rebecca" "2026-11-15" "2027-03-10" @("충무아트센터 대극장")
$html = Update-MusicalDatesAndTheaters $html "jekyll" $null $null @("블루스퀘어 신한카드홀")
$html = Update-MusicalDatesAndTheaters $html "frankenstein" "2024-06-05" "2024-09-07" @("블루스퀘어 신한카드홀")
$html = Update-MusicalDatesAndTheaters $html "deathnote" "2025-10-14" "2026-05-10" @("디큐브 링크아트센터")
$html = Update-MusicalDatesAndTheaters $html "elisabeth" "2026-08-20" "2026-11-15" @("블루스퀘어 우리은행홀")
$html = Update-MusicalDatesAndTheaters $html "hedwig" "2024-03-22" "2024-06-23" @("샤롯데씨어터")
$html = Update-MusicalDatesAndTheaters $html "hero" "2024-05-29" "2024-08-11" @("세종문화회관 대극장")
$html = Update-MusicalDatesAndTheaters $html "laundry" "2025-10-03" "2026-05-31" @("대학로 유니플렉스 2관")
$html = Update-MusicalDatesAndTheaters $html "happyend" "2025-10-30" "2026-01-25" @("두산아트센터 연강홀")
$html = Update-MusicalDatesAndTheaters $html "seopyonje" "2026-04-15" "2026-07-15" @("광림아트센터 BBCH홀")
$html = Update-MusicalDatesAndTheaters $html "bonnie" "2025-12-11" "2026-03-02" @("홍익대 대학로 아트센터 대극장")
$html = Update-MusicalDatesAndTheaters $html "rent" "2025-11-11" "2026-02-22" @("코엑스아티움")
$html = Update-MusicalDatesAndTheaters $html "lempicka" "2026-03-21" "2026-06-21" @("NOL 씨어터 코엑스 우리은행홀")
$html = Update-MusicalDatesAndTheaters $html "cabin" "2025-11-27" "2026-03-01" @("대학로 et theatre 1")
$html = Update-MusicalDatesAndTheaters $html "shadow" "2025-09-05" "2025-11-30" @("백암아트홀")
$html = Update-MusicalDatesAndTheaters $html "dwarfs" "2025-11-05" "2026-03-01" @("대학로 플러스씨어터")
$html = Update-MusicalDatesAndTheaters $html "goddess" "2024-11-26" "2025-03-03" @("대학로 유니플렉스")
$html = Update-MusicalDatesAndTheaters $html "chicago" "2026-12-05" "2027-03-21" @("LG아트센터 서울 LG SIGNATURE홀")
$html = Update-MusicalDatesAndTheaters $html "beethoven" "2026-06-10" "2026-08-25" @("세종문화회관 대극장")
$html = Update-MusicalDatesAndTheaters $html "billy" "2026-04-12" "2026-07-26" @("블루스퀘어 신한카드홀")
$html = Update-MusicalDatesAndTheaters $html "longnight" "2026-01-21" "2026-03-29" @("링크아트센터")
$html = Update-MusicalDatesAndTheaters $html "hongryeon" "2026-02-28" "2026-05-17" @("충무아트센터 중극장 블랙")
$html = Update-MusicalDatesAndTheaters $html "thedays" "2026-05-26" "2026-08-09" @("디큐브 링크아트센터")
$html = Update-MusicalDatesAndTheaters $html "western" "2026-07-01" "2026-09-27" @("대학로 유니플렉스")
$html = Update-MusicalDatesAndTheaters $html "yumi" "2026-06-30" "2026-08-23" @("예술의전당 CJ 토월극장")
$html = Update-MusicalDatesAndTheaters $html "sidereus" "2026-06-04" "2026-08-30" @("대학로 플러스씨어터")

[System.IO.File]::WriteAllText("index.html", $html, [System.Text.Encoding]::UTF8)
Write-Host "Updated musical dates and theaters successfully!"
