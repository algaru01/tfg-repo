locals {
  secret_ecr_password_name = "ecr-password"
  secret_db_password_name  = "db-password"

  pr_secret_ecr_password_name = "pr-ecr-password"
  pr_secret_db_password_name  = "pr-db-password"
}
resource "azurerm_log_analytics_workspace" "this" {
  name                = "acr-log"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "this" {
  name                           = "my-container-environment"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.this.id
  infrastructure_subnet_id       = var.subnet
  internal_load_balancer_enabled = true
}


resource "azurerm_container_app" "products" {
  name                         = "products-container-app"
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  secret {
    name  = local.pr_secret_ecr_password_name
    value = var.acr_password
  }

  secret {
    name  = local.pr_secret_db_password_name
    value = var.db_password
  }

  registry {
    server = var.acr_login_server

    username             = var.acr_username
    password_secret_name = local.pr_secret_ecr_password_name
  }

  template {
    container {
      name = "products-service"

      image  = "tfgcontainerregistry.azurecr.io/products-micro:latest"
      cpu    = 0.75
      memory = "1.5Gi"

      env {
        name  = "DATABASE_ADDRESS"
        value = var.db_address
      }

      env {
        name  = "DATABASE_PORT"
        value = var.db_port
      }

      env {
        name  = "DATABASE_USERNAME"
        value = var.db_user
      }

      env {
        name        = "DATABASE_PASSWORD"
        secret_name = local.pr_secret_db_password_name
      }

      env {
        name  = "AUTH_URL"
        value = azurerm_container_app.auth.latest_revision_fqdn //var.auth_url
      }
    }
  }

  ingress {
    transport   = "http"
    target_port = var.products_ingress_target_port

    external_enabled           = true
    allow_insecure_connections = true
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

resource "azurerm_container_app" "auth" {
  name                         = "auth-container-app"
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  secret {
    name  = local.secret_ecr_password_name
    value = var.acr_password
  }

  secret {
    name  = local.secret_db_password_name
    value = var.db_password
  }

  registry {
    server = var.acr_login_server

    username             = var.acr_username
    password_secret_name = local.secret_ecr_password_name
  }

  template {
    container {
      name = "auth-service"

      image  = "tfgcontainerregistry.azurecr.io/auth-micro:latest"
      cpu    = 0.75
      memory = "1.5Gi"

      env {
        name  = "DATABASE_ADDRESS"
        value = var.db_address
      }

      env {
        name  = "DATABASE_PORT"
        value = var.db_port
      }

      env {
        name  = "DATABASE_USERNAME"
        value = var.db_user
      }

      env {
        name        = "DATABASE_PASSWORD"
        secret_name = local.secret_db_password_name
      }
    }
  }

  ingress {
    transport   = "http"
    target_port = var.auth_ingress_target_port

    external_enabled           = true
    allow_insecure_connections = true
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}