# Script de référence (labo) : OU, groupe et utilisateur de test
$base = "DC=clinique,DC=local"
New-ADOrganizationalUnit -Name "Clinique" -Path $base
New-ADOrganizationalUnit -Name "Medecins" -Path "OU=Clinique,$base"
New-ADGroup -Name "GG-Medecins" -GroupScope Global -Path "OU=Medecins,OU=Clinique,$base"

$pwd = Read-Host "Mot de passe de medecin01" -AsSecureString
New-ADUser -Name "medecin01" -SamAccountName "medecin01" `
  -Path "OU=Medecins,OU=Clinique,$base" `
  -AccountPassword $pwd -Enabled $true
Add-ADGroupMember -Identity "GG-Medecins" -Members "medecin01"
