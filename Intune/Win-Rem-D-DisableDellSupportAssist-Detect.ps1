# Flags Dell SupportAssist services that are not disabled.
$svc = Get-Service *SupportAssist*, DellClientManagementService -ErrorAction SilentlyContinue |
    Where-Object { $_.Status -eq 'Running' -or $_.StartType -ne 'Disabled' }

if ($svc) {
    Write-Output 'Non-compliant: SupportAssist active'
    exit 1
}

Write-Output 'Compliant'
exit 0
