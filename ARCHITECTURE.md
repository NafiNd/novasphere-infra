# NovaSphere — Décisions d'architecture

## 1. Organisation DEV / PROD

Deux environnements Terraform indépendants sont définis dans `envs/dev` et `envs/prod`.

Chaque environnement dispose de son propre VPC, de ses ressources réseau et de son état Terraform.

## 2. Réseau et haute disponibilité

- Région AWS : `us-east-1`
- Deux zones de disponibilité : `us-east-1a` et `us-east-1b`
- Un VPC par environnement
- Deux sous-réseaux publics par VPC
- Un Application Load Balancer (ALB)
- Un Auto Scaling Group (ASG) avec deux instances souhaitées

Ce choix permet de répartir le trafic entre plusieurs instances et zones de disponibilité.

## 3. Automatisation

Terraform définit les ressources AWS.

Le Launch Template utilise un script `bootstrap.sh` pour installer Nginx.

GitHub Actions est configuré pour vérifier les Pull Requests, préparer les déploiements et détecter les écarts d'infrastructure.

## 4. Gestion des secrets

Les secrets applicatifs sont déclarés dans AWS SSM Parameter Store avec le type `SecureString`.

Terraform utilise une variable éphémère et `value_wo` afin d'éviter de stocker la valeur du secret dans son état.

Les instances doivent récupérer le secret grâce à un rôle IAM dédié.

## 5. Backend Terraform

Un bucket S3 commun héberge deux états distincts :

- DEV : `novasphere/dev/terraform.tfstate`
- PROD : `novasphere/prod/terraform.tfstate`

Le chiffrement et le verrouillage natif sont configurés.

## 6. Sécurité et limites

IMDSv2 est obligatoire sur les instances du Launch Template.

Le trafic HTTP vers les instances de l'ASG est limité à l'ALB.

L'ALB utilise HTTP pour la démonstration ; HTTPS serait nécessaire pour un environnement de production réel.

Les restrictions IAM d'AWS Academy empêchent actuellement de valider le déploiement complet et l'authentification OIDC de GitHub Actions.

