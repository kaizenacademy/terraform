#!/bin/bash

command_exists() {
    command -v "$@" > /dev/null 2>&1
}

install_terraform() {
    echo "Installing Terraform..."
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum -y install terraform
}

install_ansible() {
    echo "Installing Ansible..."
    sudo yum install epel-release -y
    sudo yum install ansible -y
}

function create_vms() {
    cd DO-vm-creation
    terraform init
    terraform apply --auto-approve
}

function create_hosts() {
    IP_ADDRESS_MASTER1=$(terraform output -raw master)
    IP_ADDRESS_WORKER1=$(terraform output -raw worker1)
    IP_ADDRESS_WORKER2=$(terraform output -raw worker2)
    echo -e "[master]\nmaster1 $IP_ADDRESS_MASTER1" > ../Ansible/hosts
    echo -e "[master]\nworker1 $IP_ADDRESS_WORKER1" >> ../Ansible/hosts
    echo -e "[master]\nworker2 $IP_ADDRESS_WORKER2" >> ../Ansible/hosts
}
# Check for Terraform
if command_exists terraform; then
    echo "Terraform is already installed."
else
    install_terraform
fi

# Check for Ansible
if command_exists ansible; then
    echo "Ansible is already installed."
else
    install_ansible
fi

create_vms
create_hosts