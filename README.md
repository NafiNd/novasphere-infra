# NovaSphere — Infrastructure AWS avec Terraform

Projet fil rouge Bac+5 ESGI — Terraform et automatisation du déploiement d'infrastructures cloud.

## Objectif

Déployer et automatiser une infrastructure AWS avec Terraform, en séparant les environnements DEV et PROD.

## Technologies utilisées

- Terraform 1.16.1
- AWS EC2, VPC, ALB et Auto Scaling
- AWS S3 pour le backend distant
- AWS Systems Manager Parameter Store
- GitHub Actions pour la CI/CD
- Nginx pour le serveur Web
- Ansible pour le projet initial

## Architecture

Chaque environnement possède :
- Un VPC réparti sur deux zones de disponibilité
- Deux sous-réseaux publics
- Un Application Load Balancer
- Un Auto Scaling Group
- Un Launch Template avec IMDSv2 obligatoire
- Un paramètre SSM SecureString

Les environnements DEV et PROD utilisent des états Terraform séparés dans le bucket S3 `novasphere-tfstate-naf`.

Région AWS : `us-east-1`.

## État du projet

Les configurations Terraform DEV et PROD passent la validation.

Le dernier plan PROD indique :
- 23 ressources à créer
- 0 ressource à modifier
- 0 ressource à supprimer

Le déploiement complet reste à vérifier.

## Prérequis

- Terraform 1.16.1
- AWS CLI v2 configuré
- Git
- Une clé publique SSH
- Un compte AWS avec les permissions nécessaires
- Un bucket S3 `novasphere-tfstate-naf` déjà créé

## Déploiement DEV

Depuis la racine du projet :

```bash
cd envs/dev
cp terraform.tfvars.example terraform.tfvars
```

Adapter les variables dans `terraform.tfvars`, puis fournir le secret sans l'enregistrer dans Git :

```bash
export TF_VAR_db_password='VALEUR_DE_TEST'
terraform init
terraform fmt -check
terraform validate
terraform plan
```

Après vérification du plan, et seulement si les permissions AWS le permettent :

```bash
terraform apply
terraform output alb_dns_name
unset TF_VAR_db_password
```

## Déploiement PROD

Depuis la racine du projet :

```bash
cd envs/prod
cp terraform.tfvars.example terraform.tfvars
```

Adapter les variables, puis exécuter :

```bash
export TF_VAR_db_password='VALEUR_DE_TEST_DIFFERENTE'
terraform init
terraform fmt -check
terraform validate
terraform plan
```

Après validation du plan et autorisation du déploiement :

```bash
terraform apply
terraform output alb_dns_name
unset TF_VAR_db_password
```

Ne jamais enregistrer un véritable mot de passe dans les fichiers Terraform ou dans Git.

## GitHub Actions

Deux workflows sont configurés dans `.github/workflows/`.

**terraform-pr.yml**
- Vérification du format Terraform
- Authentification AWS par OIDC
- Validation et plan Terraform DEV
- Publication du résultat sur la Pull Request

**terraform-apply.yml**
- Déploiement DEV après push sur `main`, si activé
- Déploiement PROD avec approbation GitHub
- Détection quotidienne du drift
- Déclenchement manuel de la vérification du drift

Le fonctionnement complet de ces workflows reste bloqué par les permissions IAM d'AWS Academy.

## Sécurité

Les mesures de sécurité prévues sont :

- Stockage des secrets dans AWS SSM Parameter Store (SecureString)
- Variables Terraform éphémères avec `value_wo`
- IMDSv2 obligatoire sur les instances du Launch Template
- Accès HTTP aux instances Web limité à l'ALB
- Rôle IAM dédié à la lecture des secrets SSM
- Authentification GitHub Actions par OIDC, sans clés AWS statiques
- États Terraform séparés et chiffrés dans S3

Le rôle CI utilise actuellement `AdministratorAccess`. Ses permissions devront être réduites avant une utilisation en production.

## Blocages rencontrés

Certaines fonctionnalités sont configurées, mais leur déploiement est limité par les permissions AWS Academy.

**S05 — IAM**

La création des rôles IAM est refusée (`iam:CreateRole`). Cela empêche l'attribution des permissions nécessaires aux instances EC2.

**S06 — S3**

L'importation d'un bucket S3 existant est bloquée par l'autorisation `s3:GetBucketObjectLockConfiguration`.

**S07 — GitHub Actions**

La création du fournisseur OIDC est refusée (`iam:CreateOpenIDConnectProvider`).

Le workflow GitHub Actions se déclenche, mais l'authentification AWS échoue.

Ces restrictions empêchent actuellement de valider la chaîne complète de déploiement CI/CD.

## Points restant à finaliser

- Déploiement et tests réels de l'infrastructure PROD
- Validation du fonctionnement ALB et ASG
- Vérification de la récupération du secret SSM par Nginx
- Démonstration complète de la CI/CD
- Vérification des permissions IAM et des secrets GitHub

## Documentation

- `SECURITE.md` : sécurité du projet
- `S06_COMPTE_RENDU.md` : migration Terraform et difficultés S3
- `S07_COMPTE_RENDU.md` : GitHub Actions et restrictions IAM
- `ansible/` : configuration Ansible du projet initial
- `terraform/` : infrastructure historique
- `envs/dev/` : infrastructure DEV
- `envs/prod/` : infrastructure PROD

## Conclusion

Le projet NovaSphere présente une infrastructure AWS déclarée avec Terraform, organisée en deux environnements indépendants.

Les configurations DEV et PROD sont validées syntaxiquement. Certaines fonctionnalités restent à tester ou à déployer en raison des restrictions du compte AWS Academy.
