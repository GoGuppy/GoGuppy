# Flags a Windows Update download cache over 1 GB.
$path = "$env:WinDir\SoftwareDistribution\Download"
$size = (Get-ChildItem $path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum / 1GB

if ($size -gt 1) {
    Write-Output "Non-compliant: $([math]::Round($size, 2)) GB"
    exit 1
}

Write-Output 'Compliant'
exit 0
