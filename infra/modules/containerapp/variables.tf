### Container App ###

variable "group_id" {
  type = string
}

variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "environment" {
  type = string
}

### Ingress ###

variable "external" {
  type    = bool
}

variable "ingress_target_port" {
  type = number
}

### Container ###

variable "container_image" {
  type = string
}

### Resources ###

variable "cpu" {
  type = number
}

variable "memory" {
  type = string
}

### Envs ###

variable "container_envs" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
