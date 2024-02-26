variable "do_token" {
  description = "Digital Ocean API Token"
  type        = string
}

variable "ssh_fingerprint_1" {
  description = "SSH Key Fingerprint 1"
  type        = string
}

variable "ssh_fingerprint_2" {
  description = "SSH Key Fingerprint 2"
  type        = string
}

variable master_size {
  description = "size of master node"
  type        = string
}

variable worker1_size {
  description = "size of worker1 node"
  type        = string
}

variable worker2_size {
  description = "size of worker2 node"
  type        = string
}

