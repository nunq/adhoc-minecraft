resource "hcloud_ssh_key" "adhoc-mc" {
  name       = "hetzner_key"
  public_key = file("~/.ssh/id_ed25519_adhoc-mc.pub")
}
