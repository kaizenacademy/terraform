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

locals {
  # Read the IP address for the first node, trim spaces, and then remove any newline characters
  ip_address_master1 = trimspace(replace(file("${path.module}/master1"), "/\\n/", ""))
  
  # Read the IP address for the second node
  ip_address_worker1 = trimspace(replace(file("${path.module}/worker1"), "/\\n/", ""))
  
  # If you have a third IP address for a different purpose or another node
  ip_address_worker2 = trimspace(replace(file("${path.module}/worker2"), "/\\n/", ""))
}


resource "rke_cluster" "cluster" {
  nodes {
    address          = local.ip_address_master1
    user             = "rke"
    role             = ["controlplane", "etcd"]
    ssh_key_path     = "~/.ssh/id_rsa"
  }

    nodes {
    address          = local.ip_address_worker1
    user             = "rke"
    role             = ["worker"]
    ssh_key_path     = "~/.ssh/id_rsa"
  }

    nodes {
    address          = local.ip_address_worker2
    user             = "rke"
    role             = ["worker"]
    ssh_key_path     = "~/.ssh/id_rsa"
  }


enable_cri_dockerd = true

}
