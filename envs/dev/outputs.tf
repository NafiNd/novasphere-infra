output "web_dev_public_ip" {
  description = "IP publique de l'instance web"
  value       = module.web_dev.public_ip
}

output "web_dev_instance_id" {
  description = "Identifiant de l'instance (utilise par les scripts stop/start)"
  value       = module.web_dev.instance_id
}

output "ssh_command" {
  description = "Commande de connexion"
  value       = "ssh -i ~/.ssh/novasphere admin@${module.web_dev.public_ip}"
}
