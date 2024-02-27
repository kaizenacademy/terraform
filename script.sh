#!/bin/bash

command_exists() {
    command -v "$@" > /dev/null 2>&1
}

# install_terraform() {
#     echo "Installing Terraform..."
#     sudo yum install -y yum-utils
#     sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
#     sudo yum -y install terraform
# }
install_terraform() {
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    sudo apt install terraform -y
}
install_ansible() {
    echo "Installing Ansible..."
    sudo apt update
    sudo apt install software-properties-common -y
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install ansible -y
}

# install_ansible() {
#     echo "Installing Ansible..."
#     sudo yum install epel-release -y
#     sudo yum install ansible -y
# }

function create_vms() {
    cd DO-vm-creation
    terraform init
    terraform apply --auto-approve
}

function create_hosts() {
    IP_ADDRESS_MASTER1=$(terraform output -raw master)
    IP_ADDRESS_WORKER1=$(terraform output -raw worker1)
    IP_ADDRESS_WORKER2=$(terraform output -raw worker2)
    echo -e "[master]\nmaster1 ansible_host=$IP_ADDRESS_MASTER1" > ../Ansible/hosts
    echo -e "[master]\nworker1 ansible_host=$IP_ADDRESS_WORKER1" >> ../Ansible/hosts
    echo -e "[master]\nworker2 ansible_host=$IP_ADDRESS_WORKER2" >> ../Ansible/hosts
}

ansible() {
    cd ../Ansible
    ansible-playbook -i hosts main.yml
    ansible-playbook -i hosts rke.yml
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
ansible