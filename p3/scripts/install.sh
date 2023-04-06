#!/bin/bash

# --- verify existence of commands executable ---
check_command() {
    # Return failure if it doesn't exist or is no executable
    [ -x "$(command -v $1)" ] || return 1

    return 0
}

# Install

check_command "docker" || (source install_docker.sh && install_docker)
check_command "kubectl" || (source install_kubectl.sh && install_kubectl)
check_command "k3d" || (source install_k3d.sh && install_k3d)
