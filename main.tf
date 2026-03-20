# ── Resource Group ────────────────────────────────────────────
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# ── App Service Plan ──────────────────────────────────────────
resource "azurerm_service_plan" "main" {
  name                = "${var.app_name}-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "F1"
}

# ── App Service ───────────────────────────────────────────────
resource "azurerm_linux_web_app" "main" {
  name                = var.app_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    always_on = false # not supported on F1 free tier
    application_stack {
      python_version = "3.12"
    }
    app_command_line = "uvicorn main:app --host 0.0.0.0 --port 8000"
  }

  app_settings = {
    OPENAI_API_KEY                 = var.openai_api_key
    DATABASE_URL                   = "postgresql://${var.db_admin_username}:${var.db_admin_password}@${azurerm_postgresql_flexible_server.main.fqdn}/${var.db_name}?sslmode=require"
    PYTHONUNBUFFERED               = "1"
    WEBSITES_PORT                  = "8000"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "false"
  }
}

# ── PostgreSQL Flexible Server ────────────────────────────────
resource "azurerm_postgresql_flexible_server" "main" {
  name                   = var.db_server_name
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  version                = "16"
  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  zone                   = "1"

  authentication {
    active_directory_auth_enabled = false
    password_auth_enabled         = true
  }
}

# ── PostgreSQL Database ───────────────────────────────────────
resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.main.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# ── Firewall: allow all Azure-internal traffic ────────────────
resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
