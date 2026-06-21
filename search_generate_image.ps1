$logPath = "C:\Users\yoons\.gemini\antigravity\brain\2e7414f1-beee-405e-aeb4-9852d2bb5b3a\.system_generated\logs\transcript.jsonl"
if (Test-Path $logPath) {
    $lines = Get-Content $logPath
    foreach ($line in $lines) {
        if ($line -match "generate_image") {
            # Find the Prompt and ImageName
            if ($line -match '"Prompt":"([^"]+)"') {
                $prompt = $Matches[1]
                if ($line -match '"ImageName":"([^"]+)"') {
                    $name = $Matches[1]
                    Write-Host "Name: $name | Prompt: $prompt"
                }
            }
        }
    }
} else {
    Write-Host "Log not found at $logPath"
}
