# Stops and disables every Dell SupportAssist service.
Get-Service *SupportAssist*, DellClientManagementService -ErrorAction SilentlyContinue | ForEach-Object {
    Stop-Service $_.Name -Force -ErrorAction SilentlyContinue
    Set-Service $_.Name -StartupType Disabled
}
