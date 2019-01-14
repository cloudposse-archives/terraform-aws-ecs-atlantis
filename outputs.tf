output "atlantis_ssh_public_key" {
  description = "Atlantis SSH Public Key"
  value       = "${module.atlantis_ssh_key_pair.public_key}"
}

output "badge_url" {
  description = "the url of the build badge when badge_enabled is enabled"
  value       = "${module.atlantis_web_app.badge_url}"
}
