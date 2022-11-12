### Container App ###

variable "group_id" {
  type = string
}

variable "location" {
  type = string
}

variable "environment" {
  type = string
}

### Envs ###

variable "dd_api_key" {
  type      = string
  sensitive = true
}
