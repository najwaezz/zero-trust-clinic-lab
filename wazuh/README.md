# Wazuh

- Manager sur Ubuntu (zone SOC, 192.168.99.10), agent sur Windows 10 (`win-10`, statut Active).
- Test 1 : échecs d'authentification Windows -> règle **60122** (niveau 5).
- Test 2 : logs pfSense/Suricata reçus en Syslog (UDP 514) -> règle personnalisée **100100** (niveau 8).

Fichiers : `local_rules.xml`, `ossec-syslog-snippet.conf`.
Ne jamais publier : `client.keys`, mots de passe du dashboard, `ossec.conf` complet.
