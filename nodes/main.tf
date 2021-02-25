variable "POOL_MEMBERS" {
  type = list(string)
}

variable "PARTITION" {
  default = "Common"
  type    = string
}

resource "bigip_ltm_node" "node" {
  count   = length(var.POOL_MEMBERS)
  name    = "/${var.PARTITION}/${element(var.POOL_MEMBERS, count.index)}"
  address = element(var.POOL_MEMBERS, count.index)
}

output "NODES" {
  value = bigip_ltm_node.node
}