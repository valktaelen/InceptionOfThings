#!/bin/bash

install_helm() {
    echo 'Install helm'
	curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash
}
