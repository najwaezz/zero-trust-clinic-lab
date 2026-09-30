# Architecture

## Cible (proposée)
9 VLAN internes + 1 DMZ, pfSense en frontal, Wazuh et Suricata pour la supervision.

| VLAN | Usage |
|---|---|
| 10 | Administration |
| 20 | Médecins / Infirmiers |
| 30 | Pharmacie |
| 40 | Scanner / Imagerie |
| 50 | Serveurs & SI |
| 60 | Caméras / DVR |
| 70 | Wi-Fi invités |
| 80 | Sauvegarde |
| 99 | Gestion |
| 100 | DMZ (serveur Web) |

## Maquette VMware (simplifiée)
```
Internet -- VMnet8 (NAT) -- [pfSense 2.7.2 + Suricata]
                               |-- ADMIN   192.168.10.0/24  Windows 10
                               |-- SERVERS 192.168.50.0/24  Windows Server 2022
                               |-- SOC     192.168.99.0/24  Ubuntu (Wazuh, Keycloak)
                               '-- ATTACK  192.168.70.0/24  Kali Linux
```
![Architecture cible](schema-cible.png)

![Maquette VMware](schema-maquette.png)
