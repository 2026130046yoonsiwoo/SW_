$html = [System.IO.File]::ReadAllText("index.html", [System.Text.Encoding]::UTF8)

function Add-SeasonCast($htmlText, $id, $seasonBlock) {
    $searchToken = "id: `"$id`""
    $startIdx = $htmlText.IndexOf($searchToken)
    if ($startIdx -eq -1) { 
        Write-Host "Failed to find ID: $id"
        return $htmlText 
    }
    
    $seasonsIdx = $htmlText.IndexOf("seasons: [", $startIdx)
    if ($seasonsIdx -eq -1 -or $seasonsIdx -gt $startIdx + 1500) { 
        Write-Host "Failed to find seasons array for ID: $id"
        return $htmlText 
    }
    
    # seasons: [ 바로 뒤에 인서트
    $insertIdx = $seasonsIdx + "seasons: [".Length
    $indentedBlock = "`n          $seasonBlock,"
    
    $htmlText = $htmlText.Insert($insertIdx, $indentedBlock)
    return $htmlText
}

# 8개 주요 작품의 2026 최신 캐스팅 데이터 추가
$draculaCast = @'
{
            name: "2026 시즌",
            roles: [
              { roleName: "드라큘라", actors: [{ name: "신성록" }, { name: "김준수" }, { name: "전동석" }, { name: "고은성" }] },
              { roleName: "미나", actors: [{ name: "조정은" }, { name: "박지연" }, { name: "김환희" }] },
              { roleName: "반 헬싱", actors: [{ name: "강태을" }, { name: "임정모" }] }
            ]
          }
'@

$dearevanCast = @'
{
            name: "2026 시즌",
            roles: [
              { roleName: "에반 핸슨", actors: [{ name: "박강현" }, { name: "임규형" }, { name: "나현우" }] },
              { roleName: "하이디 핸슨", actors: [{ name: "김선영" }, { name: "신영숙" }] },
              { roleName: "코너 머피", actors: [{ name: "조민호" }, { name: "김수호" }] }
            ]
          }
'@

$thedaysCast = @'
{
            name: "2026 시즌",
            roles: [
              { roleName: "정학", actors: [{ name: "엄기준" }, { name: "류수영" }, { name: "최진혁" }, { name: "김정현" }] },
              { roleName: "무영", actors: [{ name: "박규원" }, { name: "윤시윤" }, { name: "산들" }, { name: "유선호" }] }
            ]
          }
'@

$beethovenCast = @'
{
            name: "2026 시즌",
            roles: [
              { roleName: "루드비히 반 베토벤", actors: [{ name: "박효신" }, { name: "홍광호" }] },
              { roleName: "안토니 브렌타노", actors: [{ name: "윤공주" }, { name: "김지현" }, { name: "김지우" }] }
            ]
          }
'@

$billyCast = @'
{
            name: "2026 시즌",
            roles: [
              { roleName: "빌리", actors: [{ name: "김승주" }, { name: "박지후" }, { name: "김우진" }, { name: "조윤우" }] }
            ]
          }
'@

$sidereusCast = @'
{
            name: "2026 시즌",
            roles: [
              { roleName: "갈릴레오", actors: [{ name: "박민성" }, { name: "안재영" }, { name: "김지철" }] },
              { roleName: "케플러", actors: [{ name: "기세중" }, { name: "정휘" }, { name: "안지환" }, { name: "강병훈" }] }
            ]
          }
'@

$yumiCast = @'
{
            name: "2026 시즌",
            roles: [
              { roleName: "유미", actors: [{ name: "티파니 영" }, { name: "김예원" }] },
              { roleName: "109 세포", actors: [{ name: "최재림" }, { name: "정택운" }] }
            ]
          }
'@

$westernCast = @'
{
            name: "2026 시즌",
            roles: [
              { roleName: "제인 존슨", actors: [{ name: "조영화" }, { name: "이채원" }, { name: "표바하" }] },
              { roleName: "빌리 후커", actors: [{ name: "박규원" }, { name: "정욱진" }, { name: "홍기범" }] },
              { roleName: "와이어트 어프", actors: [{ name: "김도빈" }, { name: "송원근" }, { name: "최호승" }] }
            ]
          }
'@

$html = Add-SeasonCast $html "dracula" $draculaCast
$html = Add-SeasonCast $html "dearevan" $dearevanCast
$html = Add-SeasonCast $html "thedays" $thedaysCast
$html = Add-SeasonCast $html "beethoven" $beethovenCast
$html = Add-SeasonCast $html "billy" $billyCast
$html = Add-SeasonCast $html "sidereus" $sidereusCast
$html = Add-SeasonCast $html "yumi" $yumiCast
$html = Add-SeasonCast $html "western" $westernCast

[System.IO.File]::WriteAllText("index.html", $html, [System.Text.Encoding]::UTF8)
Write-Host "Added 2026 seasons cast successfully!"
