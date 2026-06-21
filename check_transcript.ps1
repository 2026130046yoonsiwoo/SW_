$logPath = "C:\Users\yoons\.gemini\antigravity\brain\2e7414f1-beee-405e-aeb4-9852d2bb5b3a\.system_generated\logs\transcript.jsonl"
if (Test-Path $logPath) {
    $lines = Get-Content $logPath
    foreach ($line in $lines) {
        if ($line -match "1781973550524" -or $line -match "1781972568128") {
            Write-Host $line
        }
    }
} else {
    Write-Host "Log not found at $logPath"
}
