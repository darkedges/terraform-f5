variable "PARTITION" {
  default = "Common"
  type = string
}

variable "CERTIFICATE" {
  type = string
}


resource "bigip_ssl_key" "private" {
  name      = "${var.CERTIFICATE}.key"
  content   = file(".ssl/${var.CERTIFICATE}.key")
  partition = var.PARTITION
}

resource "bigip_ssl_certificate" "public" {
  name      = "${var.CERTIFICATE}.certificate"
  content   = file(".ssl/${var.CERTIFICATE}.certificate")
  partition = var.PARTITION
}

resource "bigip_ltm_profile_client_ssl" "clientSSL" {
  name          = "/${var.PARTITION}/${var.CERTIFICATE}-clientssl"
  partition     = var.PARTITION
  defaults_from = "/${var.PARTITION}/clientssl"
  authenticate  = "always"
  ciphers       = "DEFAULT"
  key           = "/${var.PARTITION}/${var.CERTIFICATE}.key"
  cert          = "/${var.PARTITION}/${var.CERTIFICATE}.certificate"
  depends_on    = [bigip_ssl_key.private, bigip_ssl_certificate.public]
}

resource "bigip_ltm_profile_server_ssl" "serverSSL" {
  name          = "/${var.PARTITION}/${var.CERTIFICATE}-serverssl"
  partition     = var.PARTITION
  defaults_from = "/${var.PARTITION}/serverssl"
  authenticate  = "always"
  ciphers       = "DEFAULT"
  key           = "/${var.PARTITION}/${var.CERTIFICATE}.key"
  cert          = "/${var.PARTITION}/${var.CERTIFICATE}.certificate"
  depends_on    = [bigip_ssl_key.private, bigip_ssl_certificate.public]
}

output "CLIENT_NAME" {
  value = bigip_ltm_profile_client_ssl.clientSSL.name
  depends_on = [bigip_ltm_profile_server_ssl.serverSSL]
}

output "SERVER_NAME" {
  value = bigip_ltm_profile_server_ssl.serverSSL.name
  depends_on = [bigip_ltm_profile_server_ssl.serverSSL]
}