
# S07 — CI/CD Terraform avec GitHub Actions

## 1. Authentification OIDC

Configuration du fournisseur OIDC GitHub et du rôle IAM
`novasphere-ci-dev` dans `envs/dev/oidc.tf`.

- `terraform validate` : réussi
- `terraform plan` : réussi
- Création AWS : bloquée par les permissions IAM Academy

Erreur constatée :
`iam:CreateOpenIDConnectProvider` — AccessDenied.

## 2. Workflow Pull Request

Création de `.github/workflows/terraform-pr.yml`.

Le workflow prévoit :
- Vérification du format Terraform
- Initialisation Terraform
- Validation de la configuration
- Génération du plan
- Publication du plan en commentaire de PR

Pull Request #1 créée sur GitHub.

Le workflow s'est déclenché, mais l'authentification
AWS a échoué car le rôle OIDC n'existe pas.

## 3. Déploiement DEV et PROD

Création de `.github/workflows/terraform-apply.yml`.

- Job `apply-dev`
- Job `apply-prod` dépendant de DEV
- Environnement GitHub `prod` créé
- Relecteur obligatoire configuré
- Déploiements désactivés en attendant OIDC

## 4. Détection de dérive

Ajout d'un déclenchement nocturne et manuel.

Utilisation de :
`terraform plan -detailed-exitcode`

Codes de retour :
- 0 : aucune modification
- 1 : erreur Terraform
- 2 : modifications détectées

Le test réel reste bloqué par l'authentification AWS.

## Conclusion

La configuration CI/CD de la S07 a été préparée
et versionnée sur GitHub.

L'exécution complète nécessite un environnement AWS
autorisant la création du fournisseur OIDC et des
rôles IAM associés.

