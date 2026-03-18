output "app_url" {
  description = "Public URL of the Ganzo Golf Agent"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "db_fqdn" {
  description = "PostgreSQL server hostname"
  value       = azurerm_postgresql_flexible_server.main.fqdn
}

output "database_url" {
  description = "Full DATABASE_URL for the app (sensitive)"
  value       = "postgresql://${var.db_admin_username}:${var.db_admin_password}@${azurerm_postgresql_flexible_server.main.fqdn}/${var.db_name}?sslmode=require"
  sensitive   = true
}
