# Sets the service to automatic and starts it.
Get-Service 'ScreenConnect Client*' | Where-Object Status -ne 'Running' | ForEach-Object {
    Set-Service $_.Name -StartupType Automatic
    Start-Service $_.Name
}
