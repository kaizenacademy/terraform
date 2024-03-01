#!/bin/bash

# command_exists() {
#     command -v "$@" > /dev/null 2>&1
# }

command_exists() {
    echo "Checking command: $1"
    command -v "$1"
    result=$?
    echo "Result: $result"
    return $result
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
    echo -e "[master]\nmaster1 ansible_host=$IP_ADDRESS_MASTER1 ansible_ssh_common_args='-o StrictHostKeyChecking=no'" > ../Ansible/hosts
    echo -e "[worker]\nworker1 ansible_host=$IP_ADDRESS_WORKER1 ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> ../Ansible/hosts
    echo -e "worker2 ansible_host=$IP_ADDRESS_WORKER2 ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> ../Ansible/hosts
    echo $IP_ADDRESS_MASTER1 > ../RKE/master1
    echo $IP_ADDRESS_WORKER1 > ../RKE/worker1
    echo $IP_ADDRESS_WORKER2 > ../RKE/worker2
}
ansible-galaxy collection install community.general

ansible() {
    cd ../Ansible
    ansible-playbook -i hosts main.yml
    ansible-playbook -i hosts rke.yml
    ansible-playbook -i hosts docker.yml
}

create_rke() {
    cd ../RKE
    terraform init
    terraform apply --auto-approve
    mkdir -p ~/.kube
    terraform output -raw kube_config > ~/.kube/config
}
# Check for Terraform
if command_exists terraform; then
    echo "Terraform is already installed."
else
    install_terraform
fi

# Check for Ansible
# if command_exists ansible; then
#     echo "Ansible is already installed."
# else
#     install_ansible
# fi

if ansible --version > /dev/null 2>&1; then
    echo "Ansible is already installed."
else
    echo "Ansible is not installed."
    install_ansible
fi


create_vms
create_hosts
ansible
create_rke