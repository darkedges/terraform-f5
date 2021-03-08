variable "POOL_NAME" {
  type = string
}

variable "POOL_MEMBERS" {
  type    = list
}

variable "POOL_MEMBERS_PORT" {
  type    = number
}

variable "PARTITION" {
  default = "Common"
  type = string
}

variable "MONITOR" {
  default = "Common"
  type = string
}

variable "CREATE_NODE" {
  default = "1"
  type = number
}

variable "DEPENDS_ON" {
  type = list
  default = []
}

resource "bigip_ltm_monitor" "monitor" {
  name     = "/${var.PARTITION}/${var.POOL_NAME}_monitor"
  parent   = "/${var.PARTITION}/http"
  send     = var.MONITOR
  timeout  = "16"
  interval = "5"
}

resource "bigip_ltm_pool" "pool" {
    name                = "/${var.PARTITION}/${var.POOL_NAME}"
    monitors            = [ bigip_ltm_monitor.monitor.name ]
    allow_nat           = "yes"
    allow_snat          = "yes"
    load_balancing_mode = "round-robin"
    depends_on          = [ bigip_ltm_monitor.monitor ]
}

resource "bigip_ltm_pool_attachment" "attach_node" {
  count      = length(var.POOL_MEMBERS)
  pool       = bigip_ltm_pool.pool.name
  node       = "${lookup(element(var.POOL_MEMBERS, count.index), "name")}:${var.POOL_MEMBERS_PORT}"
  depends_on = [var.DEPENDS_ON]
}

output "POOL_CREATED" {
  value = {}
  depends_on = [bigip_ltm_pool_attachment.attach_node]
}