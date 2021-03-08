variable "POOL_NAME" {
  type = string
}

variable "VS_IPADDRESS" {
  type = string
}

variable "VS_PORT" {
  type = number
}

variable "CLIENT_SSL_PROFILE" {
  type = list
  default = []
}

variable "SERVER_SSL_PROFILE" {
  type = list
  default = []
}

variable "PARTITION" {
  default = "Common"
  type = string
}

variable "IRULES" {
  type = list
  default = []
}

variable "DEPENDS_ON" {
  type = list
  default = []
}

resource "bigip_ltm_virtual_server" "https" {
  name                       = "/${var.PARTITION}/${var.POOL_NAME}_https"
  destination                = var.VS_IPADDRESS
  port                       = var.VS_PORT
  pool                       = "/${var.PARTITION}/${var.POOL_NAME}"
  source_address_translation = "automap"
  vlans                      = ["/Common/external"]
  vlans_enabled              = true
  client_profiles            = var.CLIENT_SSL_PROFILE
  server_profiles            = var.SERVER_SSL_PROFILE
  irules                     = var.IRULES
  depends_on = [var.DEPENDS_ON]
}