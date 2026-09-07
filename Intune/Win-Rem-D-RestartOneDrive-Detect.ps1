# Flags a user with OneDrive closed or unconfigured.
if (-not (Get-Process OneDrive -ErrorAction SilentlyContinue)) { exit 1 }
if (-not (Test-Path "HKCU:\Software\Microsoft\OneDrive\Accounts\Business1")) { exit 1 }

exit 0
