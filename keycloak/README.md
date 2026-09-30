# Keycloak : fédération AD + MFA TOTP

1. Créer le **realm** et les **rôles** (ex. medecin, administratif).
2. **User Federation > Add provider > LDAP** : nom `Active Directory Clinique`, vendor *Active Directory*, connexion vers le contrôleur de domaine (`ldap://192.168.50.10:389`), Users DN du domaine `clinique.local`, compte de liaison dédié. **Ne jamais commiter le mot de passe de liaison.**
3. Synchroniser les utilisateurs depuis AD.
4. Sur l'utilisateur de test (`medecin01`) : **Required action > Configure OTP**.
5. Première connexion : scanner le QR code (Google/Microsoft Authenticator), saisir le code, valider.
6. Test : connexion = mot de passe + code TOTP.

## Export du realm
Si tu publies un export, nettoie-le d'abord : pas d'utilisateurs, pas de credentials, pas de secrets de clients ni de clés. Nomme le fichier brut `realm-export-raw.json` (ignoré par `.gitignore`).

## Production
HTTPS + certificat valide, intégration des applications via OpenID Connect ou SAML.
