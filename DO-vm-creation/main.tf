resource "digitalocean_droplet" "master" {
  name   = "ubuntu-master"
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-20-04-x64"
  region = "nyc3"
  ssh_keys = [
    var.ssh_fingerprint_1,
    var.ssh_fingerprint_2,
  ]
}

resource "digitalocean_droplet" "worker1" {
  name   = "ubuntu-worker"
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-20-04-x64"
  region = "nyc3"
  ssh_keys = [
    var.ssh_fingerprint_1,
    var.ssh_fingerprint_2,
  ]
}

