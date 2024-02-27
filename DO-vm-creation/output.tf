output master {
    value = digitalocean_droplet.master.ipv4_address
}

output worker1 {
    value = digitalocean_droplet.worker1.ipv4_address
}

output worker2 {
    value = digitalocean_droplet.worker2.ipv4_address
}