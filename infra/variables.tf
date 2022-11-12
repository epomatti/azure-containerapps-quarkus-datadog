variable "location" {
  type    = string
  default = "eastus2"
}

variable "dd_api_key" {
  type      = string
  sensitive = true
}
