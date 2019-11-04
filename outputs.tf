output "atlantis_ssh_public_key" {
  description = "Atlantis SSH Public Key"
  value       = module.ssh_key_pair.public_key
}

output "badge_url" {
  description = "The URL of the build badge when `badge_enabled` is enabled"
  value       = module.web_app.badge_url
}

output "atlantis_url" {
  description = "The URL endpoint for the atlantis server"
  value       = local.atlantis_url
}

output "atlantis_webhook_url" {
  description = "atlantis webhook URL"
  value       = local.atlantis_webhook_url
}
