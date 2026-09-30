# pfSense

> Ne jamais publier `config.xml` brut : il contient des hashes de mots de passe, certificats et clés.

## Interfaces
| Interface | Carte | Zone | Adresse |
|---|---|---|---|
| WAN | em0 | NAT | 192.168.211.133/24 |
| LAN | em1 | ADMIN | 192.168.10.1/24 |
| OPT1 | em2 | SERVERS | 192.168.50.1/24 |
| OPT2 | em3 | SOC | 192.168.99.1/24 |
| OPT3 | em4 | ATTACK | 192.168.70.1/24 |

## Règles appliquées (maquette)
| N° | Action | Source | Destination | Objectif |
|---|---|---|---|---|
| 1 | BLOCK | ATTACK net | LAN address | Protéger les postes utilisateurs |
| 2 | BLOCK | ATTACK net | SERVERS address | Protéger les serveurs |
| 3 | BLOCK | ATTACK net | This Firewall | Empêcher l'administration depuis ATTACK |
| 4 | PASS | LAN net | SERVERS net | Flux internes vers Windows Server |
| 5 | PASS | Réseaux supervisés | SOC net | Flux Wazuh et Syslog |
| 6 | PASS | SOC net | Réseaux internes | Supervision |

## Amélioration prévue : règles par ports (moindre privilège)
La règle 4 autorise tout le trafic LAN vers SERVERS. Version resserrée à valider puis à re-tester :

| Action | Source | Destination | Protocole / Ports | Usage |
|---|---|---|---|---|
| PASS | LAN net | 192.168.50.10 | TCP/UDP 53 | DNS |
| PASS | LAN net | 192.168.50.10 | TCP/UDP 88 | Kerberos |
| PASS | LAN net | 192.168.50.10 | TCP/UDP 389 | LDAP |
| PASS | LAN net | 192.168.50.10 | TCP 445 | SMB |
| BLOCK | LAN net | SERVERS net | any | Tout le reste (dont RDP 3389) |

L'export brut de la configuration n'est volontairement pas publié ; les règles sont documentées dans les tableaux ci-dessus.
