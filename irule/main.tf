variable "PARTITION" {
  default = "Common"
  type = string
}

variable "IRULE_NAME" {
  type = string
}

resource "bigip_ltm_irule" "rule" {
  name  = "/${var.PARTITION}/${var.IRULE_NAME}"
  irule = file("files/irules/${var.IRULE_NAME}.tcl")
}