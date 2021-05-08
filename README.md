# Using Terraform to deploy Cloud Manager Connector and Cloud Volumes ONTAP in Azure. <br />

### Cloud Volumes ONTAP in Azure with Terraform <br />

Terraform             |  Cloud Volumes ONTAP
:-------------------------:|:-------------------------:
![](https://github.com/jorgeedugona/CVOTerraForm/blob/main/images/terraform-icon.png)  |  ![](https://github.com/jorgeedugona/CVOTerraformAzure/blob/main/images/CVOAzure-icon.PNG)

### Prerequisites to run the script: <br />

## Prerequisites to Install Cloud Manager Connector: <br />
* [Install Azure CLI on Linux](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=dnf) <br />
* [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) <br />
* [Create an account in Cloud Central](https://cloud.netapp.com/) <br />
* [Allow outbound internet access to the connector](https://docs.netapp.com/us-en/occm/reference_networking_azure.html#outbound-internet-access) <br />
* [Authentication Token with Cloud Central](https://services.cloud.netapp.com/refresh-token) <br />

### Here are the elements that are going to be deployed to deploy Cloud Connector using the main.tf script:  <br />

1. IAM Policy and Custom IAM role. <br />
2. Security Group to allow ports SSH (22), HTTPS (443) and HTTP (80).  <br />

| Port  | Protocol | Purpose |
| :---: | :---: | :---: |
|  22   | SSH   | Provides SSH access to the Connector host |
|  80   | HTTP  | Provides HTTP access from client web browsers to the local user interface |
|  443  | HTTPs | Provides HTTPS access from client web browsers to the local user interface |

3. SSH Key Pair (to access Cloud Manager).  <br />
4. Cloud Manager VM.  <br />

## Prerequisites to deploy Cloud Volumes ONTAP:
* [Install Azure CLI on Linux](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=dnf) <br />
* [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) <br />
* [Deploy Cloud Connector](https://github.com/jorgeedugona/CVOTerraForm/wiki/1.-Deploying-Cloud-Connector-using-Terraform) <br />
* [Create 3 VPCs/Subnets for CVO HA or 1 VPC/Subnet for CVO Single Node](https://docs.netapp.com/us-en/occm/reference_networking_aws.html#example-ha-configuration) <br />
* [ONLY for CVO HA - Create a Transit Gateway across 3 AZs](https://docs.netapp.com/us-en/occm/task_setting_up_transit_gateway.html) <br />

### Here are the resources that are going to be deployed using the main.tf script for CVO:  <br />

1. Cloud Volumes ONTAP (Single Node or HA). <br />

### Terraform Configuration Files   

• terraform.tfvars - this file contains all the variables (e.g. region, vpc ID, subnet ID etc).  <br />
• terraform.tf - this file stores the format type of the variables (e.g. string, bool etc).  <br />
• main.tf  <br />
