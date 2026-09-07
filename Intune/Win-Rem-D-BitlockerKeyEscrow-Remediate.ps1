# Adds a recovery password, then escrows it to Entra.
$drive = $env:SystemDrive
$vol = Get-BitLockerVolume -MountPoint $drive

if (-not ($vol.KeyProtector | Where-Object KeyProtectorType -eq 'RecoveryPassword')) {
    Add-BitLockerKeyProtector -MountPoint $drive -RecoveryPasswordProtector
    $vol = Get-BitLockerVolume -MountPoint $drive
}

$vol.KeyProtector | Where-Object KeyProtectorType -eq 'RecoveryPassword' | ForEach-Object {
    BackupToAAD-BitLockerKeyProtector -MountPoint $drive -KeyProtectorId $_.KeyProtectorId
}
