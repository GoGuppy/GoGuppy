# Reports remote access tools other than ScreenConnect.
$names = 'TeamViewer|AnyDesk|LogMeIn|GoToAssist|GoToMyPC|Splashtop|VNC|Atera|NinjaRMM|NinjaOne|Datto|CentraStage|Kaseya|N-able|Take Control|Syncro|Action1|Pulseway|BeyondTrust|Bomgar|Dameware|Remote Utilities|Ammyy|Supremo|RustDesk|Zoho Assist|ISL Light|Parsec|DWAgent|MeshAgent|NetSupport|Radmin|ToDesk|Sunlogin|Chrome Remote Desktop'

$keys = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
)

$apps = Get-ItemProperty $keys -ErrorAction SilentlyContinue | Where-Object DisplayName -match $names | Select-Object -ExpandProperty DisplayName
$svcs = Get-Service -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match $names -or $_.Name -match $names } | Select-Object -ExpandProperty DisplayName

$found = @($apps) + @($svcs) | Sort-Object -Unique

if (-not $found) { Write-Output 'None found.'; exit 0 }

Write-Output ($found -join ' | ')
exit 1
