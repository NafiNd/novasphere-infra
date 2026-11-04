# Contribution au projet NovaSphere

## Organisation du dépôt

- `envs/dev/` : environnement de développement
- `envs/prod/` : environnement de production
- `.github/workflows/` : automatisation GitHub Actions
- `ansible/` : configuration Ansible
- `SECURITE.md` : règles de sécurité

## Méthode de travail

1. Créer une branche pour chaque modification.
2. Modifier les fichiers Terraform nécessaires.
3. Vérifier le format et la validité du code.
4. Créer une Pull Request vers `main`.
5. Faire relire les modifications avant fusion.

## Vérifications Terraform

Depuis le répertoire de l'environnement concerné :

```bash
terraform fmt -check
terraform validate
terraform plan
```

Examiner le plan avant tout déploiement.

## Sécurité

Ne jamais publier :
- De clés AWS
- De mots de passe
- De fichiers `terraform.tfvars` contenant des données sensibles
- De fichiers `terraform.tfstate`
- De clés SSH privées

Les secrets applicatifs doivent être transmis par un mécanisme sécurisé.

## Déploiement

Les déploiements DEV et PROD doivent être réalisés après validation du plan Terraform.

PROD nécessite une approbation préalable.

Les déploiements automatiques restent soumis aux permissions disponibles sur AWS Academy.

