resource "digitalocean_droplet" "master" {
  name   = "ubuntu-master"
  size   = var.master_size
  image  = "ubuntu-22-04-x64"
  region = "nyc3"
  ssh_keys = [
    var.ssh_fingerprint_1,
    var.ssh_fingerprint_2,
  ]
}

resource "digitalocean_droplet" "worker1" {
  name   = "ubuntu-worker1"
  size   = var.worker1_size
  image  = "ubuntu-22-04-x64"
  region = "nyc3"
  ssh_keys = [
    var.ssh_fingerprint_1,
    var.ssh_fingerprint_2,
  ]
}

resource "digitalocean_droplet" "worker2" {
  name   = "ubuntu-worker2"
  size   = var.worker2_size
  image  = "ubuntu-22-04-x64"
  region = "nyc3"
  ssh_keys = [
    var.ssh_fingerprint_1,
    var.ssh_fingerprint_2,
  ]
}

