#  variables
variable "hcloud_token" {
  type        = string
  description = "hetzner cloud api token"
}

# configure hcloud
provider "hcloud" {
  token = var.hcloud_token
}
