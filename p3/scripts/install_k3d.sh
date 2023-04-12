#!/bin/bash

install_k3d() {
    echo 'Install k3d'
    wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
}
