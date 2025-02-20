# minecraft server
resource "hcloud_server" "minecraft" {
  name        = "minecraft"
  image       = "ubuntu-24.04"
  server_type = "cx32"
  location    = "nbg1"
  ssh_keys    = [hcloud_ssh_key.adhoc-mc.id]
}
