#!/bin/bash
set -e

apt-get update -y
apt-get install -y nginx awscli

hostname=$(hostname)
echo "<h1>NovaSphere - $hostname</h1>" > /var/www/html/index.html
systemctl enable nginx
systemctl restart nginx

# Récupération sécurisée du secret depuis AWS SSM
install -d -m 0750 /etc/novasphere
umask 077

aws ssm get-parameter \
  --region us-east-1 \
  --name /novasphere/prod/db_password \
  --with-decryption \
  --query 'Parameter.Value' \
  --output text > /etc/novasphere/app.conf

chmod 0640 /etc/novasphere/app.conf
