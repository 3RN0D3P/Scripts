# Bitlocker Powershell Script
#################################################
# Section 1
# OS DRIVE 
#################################################

# LOG 
Start-Transcript -Path c:\Windows\temp\bitlocker_startup_log.txt

$bitlockerVolume = Get-BitlockerVolume -MountPoint $env:SystemDrive
$KeyProtectors = $bitlockerVolume.KeyProtector | Select-Object -ExpandProperty KeyprotectorType

## Si les keyProtector sont vide et le disque est chiffré -> Désactive bitlocker
if ($bitlockerVolume.KeyProtector -eq $null -and $KeyProtectors -eq $null -and $bitlockerVolume.VolumeStatus -eq "FullyDecrypted") {
    Disable-BitLocker -MountPoint $env:SystemDrive
    write-Host "BLOC 1"  
    }

## Si le keyProtector n'est pas RecoveryPassword et les disque est chiffré -> Désactive bitlocker
if (-not ('RecoveryPassword' -in $KeyProtectors) -and $bitlockerVolume.VolumeStatus -eq 'FullyEncrypted') {
    Disable-BitLocker -MountPoint $env:SystemDrive
    Write-Host "BLOC 2"
    } 

## Si les deux keyProtector TPM et RecoveryPassword sont présent et de disque est déjà chiffré -> EXIT
if ($bitlockerVolume.VolumeStatus -eq 'FullyEncrypted' -and $keyProtectors -eq 'RecoveryPassword') {
    exit
    } 

## Si le disque est déchiffré (et que TPM est activé (Validé via la GPO)) -> Chiffrement sur le disque OS
if ($bitlockerVolume.VolumeStatus -eq 'FullyDecrypted') {
    # Activer BitLocker sur le disque OS avec le protecteur de mot de passe de récupération
    Enable-BitLocker -MountPoint $env:SystemDrive -RecoveryPasswordProtector -SkipHardwareTest -UsedSpaceOnly

 }
  

################################
## Section 2
## DATA DRIVES
##############################


# Vérifie si les disques ne sont pas chiffrés
$DataDrives = Get-BitLockerVolume | Where-Object { $_.VolumeType -eq "Data" }

if ($DataDrives) {
    foreach ($drive in $DataDrives) {
        if ($drive.ProtectionStatus -eq "off") {
            # Chiffrement des disques secondaires.
            Enable-Bitlocker -Mountpoint $drive.MountPoint -RecoveryPasswordProtector -SkipHardwareTest -UsedSpaceOnly
            Enable-BitLockerAutoUnlock -MountPoint $drive.MountPoint
        } else {
            Write-Host "Le lecteur de données $($drive.MountPoint) est déjà chiffré."
            Exit
        }
    }
} else {
    Write-Host "Aucun disque de données BitLocker chiffré trouvé."
}

# Vérifie si les disques sont déjà chiffrés
$DataDrives = Get-BitLockerVolume | Where-Object { $_.VolumeType -ne "OperatingSystem" }
if ($DataDrives) {
    $encryptedDataDrives = $DataDrives | Where-Object { $_.ProtectionStatus -eq "on" }
    if ($encryptedDataDrives) {
        Write-Host "Les disques de données sont déjà chiffrés."
        Exit
    }
} else {
    Write-Host "Aucun disque de données trouvé."
}


Stop-Transcript
