# Vérifications (labo)
Get-ADDomain | Select-Object DNSRoot, NetBIOSName, DomainMode, PDCEmulator, RIDMaster, InfrastructureMaster
Get-DnsServerZone
Resolve-DnsName clinique.local

# Depuis le poste Windows 10 (zone ADMIN) : services attendus
foreach ($p in 53,88,389,445,3389) {
  Test-NetConnection 192.168.50.10 -Port $p | Select-Object RemotePort, TcpTestSucceeded
}
