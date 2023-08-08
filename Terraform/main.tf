resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "digitalocean_ssh_key" "foodrec_key" {
  name       = "Terraform ssh key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "digitalocean_droplet" "foodrec_digitalocean" {
  image    = local.instance.image
  name     = local.instance.name
  region   = local.instance.region
  size     = local.instance.size
  ssh_keys = [digitalocean_ssh_key.foodrec_key.fingerprint]
}

resource "cloudflare_record" "foodrec_cloudflare" {
  for_each   = local.instance.dns_record
  depends_on = [digitalocean_droplet.foodrec_digitalocean]
  zone_id    = var.zone_id
  name       = each.value
  value      = digitalocean_droplet.foodrec_digitalocean.ipv4_address
  type       = "A"
  proxied    = true
}