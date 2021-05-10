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

resource "azurerm_role_definition" "ClouManagerRole" {
  name        = "Cloud Manager Role"
  scope       = "/subscriptions/${var.subscription_id}"
  description = "This is a custom role created via Terraform for Cloud Manager Connector"

  permissions {
    actions = [
      "Microsoft.Compute/disks/delete",
      "Microsoft.Compute/disks/read",
      "Microsoft.Compute/disks/write",
      "Microsoft.Compute/locations/operations/read",
      "Microsoft.Compute/locations/vmSizes/read",
      "Microsoft.Resources/subscriptions/locations/read",
      "Microsoft.Compute/operations/read",
      "Microsoft.Compute/virtualMachines/instanceView/read",
      "Microsoft.Compute/virtualMachines/powerOff/action",
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Compute/virtualMachines/restart/action",
      "Microsoft.Compute/virtualMachines/deallocate/action",
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/vmSizes/read",
      "Microsoft.Compute/virtualMachines/write",
      "Microsoft.Compute/images/write",
      "Microsoft.Compute/images/read",
      "Microsoft.Network/locations/operationResults/read",
      "Microsoft.Network/locations/operations/read",
      "Microsoft.Network/networkInterfaces/read",
      "Microsoft.Network/networkInterfaces/write",
      "Microsoft.Network/networkInterfaces/join/action",
      "Microsoft.Network/networkSecurityGroups/read",
      "Microsoft.Network/networkSecurityGroups/write",
      "Microsoft.Network/networkSecurityGroups/join/action",
      "Microsoft.Network/virtualNetworks/read",
      "Microsoft.Network/virtualNetworks/checkIpAddressAvailability/read",
      "Microsoft.Network/virtualNetworks/subnets/read",
      "Microsoft.Network/virtualNetworks/subnets/write",
      "Microsoft.Network/virtualNetworks/subnets/virtualMachines/read",
      "Microsoft.Network/virtualNetworks/virtualMachines/read",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Resources/deployments/operations/read",
      "Microsoft.Resources/deployments/read",
      "Microsoft.Resources/deployments/write",
      "Microsoft.Resources/resources/read",
      "Microsoft.Resources/subscriptions/operationresults/read",
      "Microsoft.Resources/subscriptions/resourceGroups/delete",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Resources/subscriptions/resourcegroups/resources/read",
      "Microsoft.Resources/subscriptions/resourceGroups/write",
      "Microsoft.Storage/checknameavailability/read",
      "Microsoft.Storage/operations/read",
      "Microsoft.Storage/storageAccounts/listkeys/action",
      "Microsoft.Storage/storageAccounts/read",
      "Microsoft.Storage/storageAccounts/delete",
      "Microsoft.Storage/storageAccounts/regeneratekey/action",
      "Microsoft.Storage/storageAccounts/write",
      "Microsoft.Storage/usages/read",
      "Microsoft.Compute/snapshots/write",
      "Microsoft.Compute/snapshots/read",
      "Microsoft.Compute/availabilitySets/write",
      "Microsoft.Compute/availabilitySets/read",
      "Microsoft.Compute/disks/beginGetAccess/action",
      "Microsoft.MarketplaceOrdering/offertypes/publishers/offers/plans/agreements/read",
      "Microsoft.MarketplaceOrdering/offertypes/publishers/offers/plans/agreements/write",
      "Microsoft.Network/loadBalancers/read",
      "Microsoft.Network/loadBalancers/write",
      "Microsoft.Network/loadBalancers/delete",
      "Microsoft.Network/loadBalancers/backendAddressPools/read",
      "Microsoft.Network/loadBalancers/backendAddressPools/join/action",
      "Microsoft.Network/loadBalancers/frontendIPConfigurations/read",
      "Microsoft.Network/loadBalancers/loadBalancingRules/read",
      "Microsoft.Network/loadBalancers/probes/read",
      "Microsoft.Network/loadBalancers/probes/join/action",
      "Microsoft.Authorization/locks/*",
      "Microsoft.Network/routeTables/join/action",
      "Microsoft.NetApp/netAppAccounts/capacityPools/volumes/write",
      "Microsoft.NetApp/netAppAccounts/capacityPools/volumes/read",
      "Microsoft.NetApp/netAppAccounts/capacityPools/volumes/delete",
      "Microsoft.NetApp/netAppAccounts/write",
      "Microsoft.NetApp/netAppAccounts/read",
      "Microsoft.NetApp/netAppAccounts/capacityPools/write",
      "Microsoft.NetApp/netAppAccounts/capacityPools/read",
      "Microsoft.NetApp/netAppAccounts/capacityPools/volumes/delete",
      "Microsoft.Network/privateEndpoints/write",
      "Microsoft.Storage/storageAccounts/PrivateEndpointConnectionsApproval/action",
      "Microsoft.Storage/storageAccounts/privateEndpointConnections/read",
      "Microsoft.Network/privateEndpoints/read",
      "Microsoft.Network/privateDnsZones/write",
      "Microsoft.Network/privateDnsZones/virtualNetworkLinks/write",
      "Microsoft.Network/virtualNetworks/join/action",
      "Microsoft.Network/privateDnsZones/A/write",
      "Microsoft.Network/privateDnsZones/read",
      "Microsoft.Network/privateDnsZones/virtualNetworkLinks/read",
      "Microsoft.Resources/deployments/operationStatuses/read",
      "Microsoft.Insights/Metrics/Read",
      "Microsoft.Compute/virtualMachines/extensions/write",
      "Microsoft.Compute/virtualMachines/extensions/read",
      "Microsoft.Compute/virtualMachines/extensions/delete",
      "Microsoft.Compute/virtualMachines/delete",
      "Microsoft.Network/networkInterfaces/delete",
      "Microsoft.Network/networkSecurityGroups/delete",
      "Microsoft.Resources/deployments/delete",
      "Microsoft.Compute/diskEncryptionSets/read"
    ]
    not_actions = []
  }

  assignable_scopes = [
    "/subscriptions/${var.subscription_id}",
  ]
}


resource "azurerm_network_security_group" "SGCloudManagerConnector" {
  name                = "TFSecurityGroupCloudManager"
  location            = var.location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "HTTP_rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPs_rule"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH_rule"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "InternetConnectivity"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Cloud Manager Connector Azure Terraform"
  }
}


resource "netapp-cloudmanager_connector_azure" "cm-azure" {
  provider                    = netapp-cloudmanager
  name                        = "TFConnectorAzure"
  location                    = var.location
  subscription_id             = var.subscription_id
  company                     = var.company
  resource_group              = var.resource_group
  subnet_id                   = var.subnet_name
  vnet_id                     = var.vnet_name
  network_security_group_name = azurerm_network_security_group.SGCloudManagerConnector.name
  associate_public_ip_address = var.publicIP
  admin_password              = var.admin_password
  admin_username              = var.admin_username
}


data "azurerm_virtual_machine" "occm-vm" {
  depends_on          = [netapp-cloudmanager_connector_azure.cm-azure]
  name                = "TFConnectorAzure"
  resource_group_name = var.resource_group
}

resource "azurerm_role_assignment" "occm-role-assignment" {
  depends_on         = [azurerm_role_definition.ClouManagerRole]
  scope              = "/subscriptions/${var.subscription_id}"
  role_definition_id = azurerm_role_definition.ClouManagerRole.role_definition_resource_id
  principal_id       = data.azurerm_virtual_machine.occm-vm.identity.0.principal_id
}

