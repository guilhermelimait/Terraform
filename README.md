# Terraform

Terraform templates for provisioning Azure infrastructure.

## Configurations

**AzureServer01**
Provisions a Windows Server 2019 virtual machine on Azure with supporting resources: resource group, VNet, subnet, NIC, storage account, Automation Account, and a private DNS zone. VM size is Standard_DS1_v2.

**AzureServer02**
Similar VM configuration with an additional `site/` subfolder containing web content for deployment onto the provisioned server.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

Refer to `commands.txt` for additional reference commands. Each directory has a `variables.tf` defining configurable parameters (prefix, location, tags).

## Requirements

- Terraform
- Azure CLI or a service principal configured for the `azurerm` provider

## License

MIT
