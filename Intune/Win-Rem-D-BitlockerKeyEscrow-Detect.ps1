# Flags encrypted OS drives with no recovery password.
$vol = Get-BitLockerVolume -MountPoint $env:SystemDrive

if ($vol.ProtectionStatus -ne 'On') {
    Write-Output 'Compliant: BitLocker off, policy handles that'
    exit 0
}

if ($vol.KeyProtector | Where-Object KeyProtectorType -eq 'RecoveryPassword') {
    Write-Output 'Compliant'
    exit 0
}

Write-Output 'Non-compliant: no recovery password'
exit 1
