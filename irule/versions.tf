terraform {
  required_providers {
    bigip = {
      source = "f5networks/bigip"
      version = ">= 1.7.0"
    }
  }
  required_version = ">= 0.14"
}
