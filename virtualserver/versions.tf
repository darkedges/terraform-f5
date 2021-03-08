terraform {
  required_providers {
    bigip = {
      source = "darkedges.com/f5networks/bigip"
      version = ">= 1.7.1"
    }
  }
  required_version = ">= 0.14"
}
