variable "F5_ADDRESS" {}
variable "F5_USERNAME" {}
variable "F5_PASSWORD" {}
variable "FRIM_POOL_NAME" {}
variable "FRIM_POOL_MEMBERS" {}
variable "FRIM_POOL_MEMBERS_PORT" {}
variable "FRIM_MONITOR" {}
variable "FRIM_VS_IPADDRESS" {}
variable "FRIM_VS_PORT" {}
variable "FRIG_POOL_NAME" {}
variable "FRIG_POOL_MEMBERS_PORT" {}
variable "FRIG_MONITOR" {}
variable "FRIG_VS_IPADDRESS" {}
variable "FRIG_VS_PORT" {}
variable "PARTITION" {}
variable "CERTIFICATE" {}

provider "bigip" {
    address = var.F5_ADDRESS
    username = var.F5_USERNAME
    password = var.F5_PASSWORD
}

module "Nodes" {
  source            = "./nodes"
  POOL_MEMBERS      = var.FRIM_POOL_MEMBERS
}

module "FRIMPool" {
  source            = "./pool"
  POOL_NAME         = var.FRIM_POOL_NAME
  POOL_MEMBERS      = module.Nodes.NODES
  POOL_MEMBERS_PORT = var.FRIM_POOL_MEMBERS_PORT
  MONITOR           = var.FRIM_MONITOR
}

module "FRIGPool" {
  source            = "./pool"
  POOL_NAME         = var.FRIG_POOL_NAME
  POOL_MEMBERS      = module.Nodes.NODES
  POOL_MEMBERS_PORT = var.FRIG_POOL_MEMBERS_PORT
  MONITOR           = var.FRIG_MONITOR
}

module "SSLServer" {
 source            = "./sslprofile"
 CERTIFICATE       = var.CERTIFICATE
}

#module "FRIMVirtualServer" {
#  source       = "./virtualserver"
#  POOL_NAME    = var.FRIM_POOL_NAME
#  VS_IPADDRESS = var.FRIM_VS_IPADDRESS
#  VS_PORT      = var.FRIM_VS_PORT
#  CLIENT_SSL_PROFILE = [module.SSLServer.CLIENT_NAME]
#  SERVER_SSL_PROFILE = [module.SSLServer.SERVER_NAME]
#
#  DEPENDS_ON = [
#    module.FRIMPool.POOL_CREATED
#  ]
#}

module "FRIGVirtualServer" {
  source       = "./virtualserver"
  POOL_NAME    = var.FRIG_POOL_NAME
  VS_IPADDRESS = var.FRIG_VS_IPADDRESS
  VS_PORT      = var.FRIG_VS_PORT
  CLIENT_SSL_PROFILE = [module.SSLServer.CLIENT_NAME]
  SERVER_SSL_PROFILE = [module.SSLServer.SERVER_NAME]

  DEPENDS_ON = [
      module.FRIGPool.POOL_CREATED
    ]
}