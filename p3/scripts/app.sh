#!/usr/bin/env bash

# --- helper functions for logs ---
info()
{
    echo '[INFO] ' "$@"
}

# --- use sudo if we are not already root ---
SUDO=sudo
if [ $(id -u) -eq 0 ]; then
    SUDO=
fi

# --- verify existence of commands executable ---
check_command() {
    # Return failure if it doesn't exist or is no executable
    [ -x "$(command -v $1)" ] || return 1

    return 0
}

install_docker() {
    info 'Installing docker...'

    # apt
    $SUDO apt update
    $SUDO apt install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    
    # Docker's key & repository
    $SUDO mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker Engine
    $SUDO apt update
    
    VERSION=5:20.10.23~3-0~ubuntu-jammy
    $SUDO apt install -y docker-ce=$VERSION docker-ce-cli=$VERSION containerd.io docker-compose-plugin    

    # Docker as non-root user
    # $SUDO groupadd docker
    $SUDO usermod -aG docker $USER
    newgrp docker

    info 'docker installed'
}


install_kubectl() {
    info 'Installing kubectl...'

    VERSION=v1.26.0
    curl -LO "https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl"

    # Checksum
    curl -LO "https://dl.k8s.io/${VERSION}/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256) kubectl" | sha256sum --check
    rm -rf kubectl.sha256

    # Install
    $SUDO install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    # kubctl as non-root user
    $SUDO groupadd kubelet
    $SUDO usermod -aG kubelet $USER
    newgrp kubelet

    info 'kubectl installed'
}

install_k3d() {
    info 'Installing k3d...'

    VERSION=v5.4.6
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=$VERSION bash

    info 'k3d installed'
}


check_command "docker" || install_docker
check_command "kubectl" || install_kubectl
check_command "k3d" || install_k3d
