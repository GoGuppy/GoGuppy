$up = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
if ($up.Days -ge 7) { exit 1 } else { exit 0 }
