resource "digitalocean_droplet" "master" {
  name    = "ubuntu-master"
  size    = var.master_size
  image   = "ubuntu-22-04-x64"
  region  = "nyc3"
  ssh_keys = [
    var.ssh_fingerprint_1,
    var.ssh_fingerprint_2,
  ]

  provisioner "remote-exec" {
    inline = [
      "swapoff -a",
      "sed -i '/ swap / s/^/#/' /etc/fstab",
      "useradd rke",
      "usermod -aG sudo rke",
      "mkdir -p /home/rke/.ssh",
      "cp /root/.ssh/authorized_keys /home/rke/.ssh/",
      "chown -R rke:rke /home/rke/.ssh",
      "chmod 700 /home/rke/.ssh",
      "chmod 600 /home/rke/.ssh/authorized_keys"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/id_rsa")
      host        = self.ipv4_address
    }
  }
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

  provisioner "remote-exec" {
    inline = [
      "swapoff -a",
      "sed -i '/ swap / s/^/#/' /etc/fstab",
      "useradd rke",
      "usermod -aG sudo rke",
      "mkdir -p /home/rke/.ssh",
      "cp /root/.ssh/authorized_keys /home/rke/.ssh/",
      "chown -R rke:rke /home/rke/.ssh",
      "chmod 700 /home/rke/.ssh",
      "chmod 600 /home/rke/.ssh/authorized_keys"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/id_rsa")
      host        = self.ipv4_address
    }
  }
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

  provisioner "remote-exec" {
    inline = [
      "swapoff -a",
      "sed -i '/ swap / s/^/#/' /etc/fstab",
      "useradd rke",
      "usermod -aG sudo rke",
      "mkdir -p /home/rke/.ssh",
      "cp /root/.ssh/authorized_keys /home/rke/.ssh/",
      "chown -R rke:rke /home/rke/.ssh",
      "chmod 700 /home/rke/.ssh",
      "chmod 600 /home/rke/.ssh/authorized_keys"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/id_rsa")
      host        = self.ipv4_address
    }
  }
}

