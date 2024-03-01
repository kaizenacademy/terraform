output kube_config {
    sensitive = true
    value = rke_cluster.cluster.kube_config_yaml
}