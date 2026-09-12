# Launches OneDrive from the per user or machine path.
$p = "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"
if (-not (Test-Path $p)) { $p = "$env:ProgramFiles\Microsoft OneDrive\OneDrive.exe" }
Start-Process $p -ArgumentList "/background"
