terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    rke = {
      source  = "rancher/rke"
      version = "~> 1.0"
    }
  }
  required_version = ">= 0.12"
}


provider "rke" {}

provider "digitalocean" {
  token = var.do_token
}

resource "rke_cluster" "cluster" {
  nodes {
    address          = "159.65.242.44"
    user             = "rke"
    role             = ["controlplane", "etcd"]
    ssh_key_path     = "~/.ssh/id_rsa"
  }

    nodes {
    address          = "167.99.57.184"
    user             = "rke"
    role             = ["worker"]
    ssh_key_path     = "~/.ssh/id_rsa"
  }

    nodes {
    address          = "159.65.242.248"
    user             = "rke"
    role             = ["worker"]
    ssh_key_path     = "~/.ssh/id_rsa"
  }


enable_cri_dockerd = true

}
