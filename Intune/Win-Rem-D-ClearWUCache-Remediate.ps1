# Stops update services, clears the cache, starts them.
Stop-Service wuauserv, bits -Force
Remove-Item "$env:WinDir\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service bits, wuauserv
