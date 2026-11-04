# S05 — Audit de sécurité NovaSphere

## Étape 1 — Recherche des secrets

Recherche effectuée avec git grep et grep dans envs/dev.

Résultat : aucune référence à un mot de passe trouvée.

Le projet actuel ne contient pas la variable db_password
présente dans le scénario théorique du TP.

Les preuves de fuite initiales ne sont donc pas reproductibles
sur cette configuration.

Les vérifications du state Terraform et du user_data
restent à effectuer.




## IAM et moindre privilège

Le rôle IAM `novasphere-dev-web` a été défini dans Terraform
avec une politique autorisant uniquement `ssm:GetParameter`
sur `/novasphere/dev/db_password`.

La configuration Terraform a été validée avec succès.

Lors du `terraform apply`, AWS Academy Learner Lab a refusé
la création du rôle :

AccessDenied: iam:CreateRole

Le rôle préexistant `LabRole` a été examiné comme alternative.
La simulation IAM indique `allowed` pour la lecture du
paramètre `/novasphere/prod/db_password`.

Ce rôle ne garantit donc pas le moindre privilège demandé.

Les tests EC2 DEV autorisé / PROD refusé restent non réalisés.
Ils nécessitent un rôle IAM correctement restreint et les
autorisations AWS nécessaires à son déploiement.


## Analyse de sécurité Checkov

Commande exécutée :
`checkov -d envs/dev --framework terraform --compact`

### Correction 1 — CKV_AWS_79
Ressource : aws_launch_template.web

Activation obligatoire d'IMDSv2 avec :
- http_endpoint = "enabled"
- http_tokens = "required"

Résultat Checkov : PASSED.

### Correction 2 — CKV_AWS_131
Ressource : aws_lb.web

Activation de `drop_invalid_header_fields = true`
pour rejeter les en-têtes HTTP invalides.

Résultat Checkov : PASSED.

### Exception justifiée — CKV_AWS_260
Ressource : aws_security_group.alb

Le port HTTP 80 reste accessible publiquement pour
la démonstration du TP S04.

Cette exception est limitée à l'environnement pédagogique.
En production, HTTPS avec un certificat TLS serait nécessaire.

Résultat Checkov : SKIPPED.

### Limites restantes
D'autres contrôles Checkov restent en échec.
L'analyse complète n'est donc pas entièrement conforme.

Le déploiement du rôle IAM spécifique reste bloqué par
les restrictions AWS Academy sur iam:CreateRole.
