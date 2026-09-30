# Script de référence (labo) : installation AD DS + DNS et création de la forêt clinique.local
# Adresse statique du serveur : 192.168.50.10/24, passerelle 192.168.50.1
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

$dsrm = Read-Host "Mot de passe DSRM" -AsSecureString   # jamais en dur dans le script
Install-ADDSForest `
  -DomainName "clinique.local" `
  -DomainNetbiosName "CLINIQUE" `
  -InstallDns `
  -SafeModeAdministratorPassword $dsrm
