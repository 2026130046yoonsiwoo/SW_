$html = [System.IO.File]::ReadAllText("index.html", [System.Text.Encoding]::UTF8)

$checks = @("profile-auth-btn", "togglePasswordVisibility", "login-password", "signup-password")
foreach ($c in $checks) {
    $contains = $html.Contains($c)
    Write-Host "$c : $contains"
}
