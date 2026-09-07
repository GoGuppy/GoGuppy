# Flags a stopped ScreenConnect client service.
$svc = Get-Service 'ScreenConnect Client*'

if (-not $svc) {
    Write-Output 'Compliant: not installed'
    exit 0
}

if ($svc | Where-Object Status -ne 'Running') {
    Write-Output 'Non-compliant: stopped'
    exit 1
}

Write-Output 'Compliant'
exit 0
