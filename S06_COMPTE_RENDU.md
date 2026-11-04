# S06 — Cycle de vie du state Terraform

## Étape 1 — Import S3

Le bucket `novasphere-uploads-naf` a été créé manuellement dans AWS, en région `us-east-1`.

L'import déclaratif a été préparé avec un bloc `import` et une ressource `aws_s3_bucket`.

L'import a échoué en raison d'une restriction AWS Academy : refus explicite de l'action `s3:GetBucketObjectLockConfiguration` par une Service Control Policy (SCP).

Le bucket existe toujours sur AWS, mais n'a pas été intégré au state Terraform.

## Étape 2 — Déplacement avec moved

Le module `web` a été renommé en `web_dev`.

Un bloc `moved` permet à Terraform de reconnaître les ressources existantes sous leurs nouvelles adresses.

Le plan confirme le déplacement des ressources EC2 et Security Group, sans destruction prévue.

Le déplacement n'a pas encore été appliqué au state.

## Étape 3 — Détection et correction du drift

Le port TCP 8080 a été ouvert manuellement sur le Security Group DEV.

Terraform a détecté la différence entre le code et l'infrastructure AWS.

**Décision : le code a raison.**

Le port 8080 n'est pas nécessaire au fonctionnement de l'application et son ouverture à Internet augmente inutilement la surface d'attaque.

La règle a été supprimée et le plan est revenu à son état initial.

## Étape 4 — Retrait avec removed

L'import de l'étape 1 ayant échoué, le bucket n'était pas présent dans le state.

Il n'était donc pas possible de démontrer un retrait effectif avec le bloc `removed`.

La commande `aws s3api head-bucket` confirme que le bucket existe toujours sur AWS.

## Bilan

- Import S3 : bloqué par les permissions AWS Academy.
- Déplacement : validé dans le plan, sans destruction.
- Drift : détecté et corrigé.
- Removed : non réalisable sans import préalable.
- Aucune commande `terraform state mv` ou `terraform state rm` utilisée.

Le plan final présente trois créations et deux modifications en attente, provenant de la S05 et non du déplacement S06.
