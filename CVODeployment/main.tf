# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
    netapp-cloudmanager = {
      source = "NetApp/netapp-cloudmanager"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  skip_provider_registration = "true"
}

provider "netapp-cloudmanager" {
  refresh_token = var.token
}

data "azurerm_subscription" "current" {
}

output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}

output "current_subscription_display_id" {
  value = data.azurerm_subscription.current.id
}


resource "netapp-cloudmanager_cvo_azure" "cvo-azure" {
  provider                    = netapp-cloudmanager
  name                        = var.ha ? "TerraformCVOHighAvailable" : "TerraformCVOSingleNode"
  location                    = var.location
  subscription_id             = var.subscription_id
  subnet_id                   = var.private_subnet_name
  vnet_id                     = var.vnet_name
  vnet_resource_group         = var.vnet_resource_group
  resource_group              = var.resource_group
  allow_deploy_in_existing_rg = var.allow_deploy_in_existing_rg
  data_encryption_type        = "AZURE"
  azure_tag {
    tag_key   = "CVO-Azure"
    tag_value = "Terraform"
  }
  azure_tag {
    tag_key   = "Region"
    tag_value = var.location
  }
  storage_type                 = "Premium_LRS"
  instance_type                = var.instance_type
  svm_password                 = var.password
  client_id                    = var.client_id
  workspace_id                 = var.workspace_id
  capacity_tier                = "Blob"
  writing_speed_state          = "NORMAL"
  is_ha                        = var.ha
  license_type                 = var.ha ? "azure-ha-cot-premium-byol" : "azure-cot-premium-byol"
  platform_serial_number_node1 = var.ha ? var.license_node_1 : ""
  platform_serial_number_node2 = var.ha ? var.license_node_2 : ""
  serial_number                = var.ha ? "" : var.license_single_node
}

