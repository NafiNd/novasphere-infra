#!/bin/bash
apt-get update -y
apt-get install -y nginx
hostname=$(hostname)
echo "<h1>NovaSphere - $hostname</h1>" > /var/www/html/index.html
systemctl enable nginx
systemctl restart nginx
