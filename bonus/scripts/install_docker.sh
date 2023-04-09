#!/bin/bash

install_docker() {
    echo 'Install docker'
    # Dependencies
    sudo apt-get -y update
    sudo apt-get remove docker docker-engine docker.io containerd runc
    sudo apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common

    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg -y

    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    sudo apt-get -y update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y

    # Start service
    sudo systemctl enable --now docker

    sudo groupadd docker
    sudo usermod -aG docker $USER
}
