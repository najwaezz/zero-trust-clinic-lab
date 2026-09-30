# Zero Trust Clinic Lab

**A lab for a secure network architecture in a healthcare setting: pfSense segmentation, Wazuh monitoring, Suricata detection, Active Directory and Keycloak MFA, all derived from an EBIOS Risk Manager risk assessment.**

🇫🇷 [Version française](README.md)

![Target architecture](architecture/schema-cible.png)

## Context and goal
Healthcare organizations are prime targets (ransomware, medical data theft). This project, done during an engineering internship (EMSI Tangier, network & cybersecurity track), starts from an audit of an almost flat network and ends with a **segmented target architecture**, whose key mechanisms are **validated in an isolated VMware lab**.

The case study is **anonymized**: no real client data, credentials or production configuration are included.

## My role
- Analysis of Nmap scan results and mapping of the existing network
- **EBIOS Risk Manager** risk assessment (5 workshops): assets, risk sources, 5 scenarios, P1/P2/P3 treatment plan
- Target architecture design (9 VLANs + DMZ), addressing plan and flow matrix
- VMware lab build (5 VMs, 4 zones + WAN)
- **pfSense** configuration (interfaces, NAT, inter-zone rules)
- **Active Directory / DNS** deployment (`clinique.local`) and Windows 10 domain join
- **Wazuh** deployment (manager + Windows agent) and **Suricata → Wazuh** integration
- **Suricata** deployed as an IDS on the untrusted zone
- **Keycloak** federated with Active Directory (LDAP) with TOTP second factor
- Validation tests and documentation

## Lab architecture

| Zone | Subnet | Role | VM |
|---|---|---|---|
| WAN | 192.168.211.0/24 | Internet access (NAT) | pfSense |
| ADMIN (LAN) | 192.168.10.0/24 | Internal users | Windows 10 |
| SERVERS | 192.168.50.0/24 | Critical servers | Windows Server 2022 (AD DS, DNS) |
| SOC | 192.168.99.0/24 | Monitoring and authentication | Ubuntu (Wazuh, Keycloak) |
| ATTACK | 192.168.70.0/24 | Untrusted zone, controlled tests | Kali Linux |

![VMware lab](architecture/schema-maquette.png)

The 9 VLANs of the target design are grouped into 4 zones in the lab due to hardware limits. See [`architecture/`](architecture/).

## Security approach (EBIOS RM)

| Scenario | Risk | Measures implemented in the lab |
|---|---|---|
| SO1 | Ransomware via an exposed workstation | pfSense segmentation, Wazuh monitoring, Suricata detection, MFA |
| SO2 | Insider data exfiltration | AD access control, least privilege, Wazuh, MFA |
| SO3 | Compromise via a third-party provider | Temporary accounts, pfSense rules, MFA, monitoring |
| SO4 | Intrusion via DVR / Wi-Fi | Isolated zone, pfSense rules, Suricata |
| SO5 | Leakage via printers | Isolated network, pfSense filtering |

Organizational measures (3-2-1 backups, e-mail filtering, USB blocking, third-party access policy) are **recommendations** in the treatment plan, not deployed in the lab.

## Demo: from attack to alert

A controlled scan is launched from Kali (ATTACK zone) against the Windows server (SERVERS zone).

**1. pfSense blocks it**: all ports show as `filtered`.

![Nmap filtered](screenshots/16-nmap-filtered.png)

**2. pfSense logs confirm the block** (ATTACK em4 → SERVERS).

![pfSense logs](screenshots/17-pfsense-block-logs.png)

**3. Suricata detects, Wazuh centralizes**: custom rule 100100, level 8.

![Wazuh 100100](screenshots/12-wazuh-rule-100100.png)

## Results

| Test | Result |
|---|---|
| Inter-zone segmentation | Allowed flows work, ATTACK isolated |
| ATTACK → SERVERS scan | Ports `filtered`, block visible in logs |
| `clinique.local` domain + DNS | Windows 10 joined, domain account login works |
| Wazuh | Agent active, failed logons detected (rule 60122) |
| Suricata → Wazuh | TCP scan detected, alert centralized (rule 100100) |
| Keycloak + AD | Login with password + TOTP code |

All captures: [`screenshots/`](screenshots/).

## Technologies
pfSense 2.7.2 · Suricata · Wazuh · Active Directory / DNS (Windows Server 2022) · Keycloak · Kali Linux · Nmap · VMware Workstation

## Repository layout
```
architecture/       diagrams and addressing plan
pfsense/            interfaces and rule matrix
suricata/           local rule
wazuh/              custom rule, config snippet
keycloak/           LDAP + MFA procedure
active-directory/   reference PowerShell scripts
screenshots/        validation screenshots
docs/               documentation
```

## Limitations and next steps
- Small virtual lab; DMZ and real devices (printers, DVR) not reproduced.
- **Port-level rule hardening**: the LAN → SERVERS rule is still broad; a tighter version (DNS/Kerberos/LDAP/SMB only) is proposed in [`pfsense/`](pfsense/) and still needs testing.
- Keycloak is lab-only: production needs HTTPS, a valid certificate and application integration (OpenID Connect / SAML).
- Suricata runs as IDS (no automatic blocking); IPS mode to be evaluated.
- Results must be confirmed through acceptance testing before any real use.

## Disclaimer
Educational repository. Offensive tests were run only in an isolated lab. Do not reuse these configurations as-is in production.

## Author
Najoua Ezzarouali, engineering student (network & cybersecurity), EMSI Tangier.
