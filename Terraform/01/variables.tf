variable "prefix" {
  default = "imersaoazure"
}

variable "location" {
  default = "East US"
}

variable "tags" {
  type = "map"
  default = {
    environment = "development",
    owner       = "Daniel Santos",
    managedby   = "terraform"
  }
}
