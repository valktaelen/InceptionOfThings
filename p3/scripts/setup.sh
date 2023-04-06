#!/bin/sh

echo -e "\033[0;32m╔═══════════════════╗\033[0m"
echo -e "\033[0;32m║ Starting setup... ║\033[0m"
echo -e "\033[0;32m╚═══════════════════╝\033[0m"
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update

echo -e "\033[0;32m╔═════════════════╗\033[0m"
echo -e "\033[0;32m║ Setup docker... ║\033[0m"
echo -e "\033[0;32m╚═════════════════╝\033[0m"
sudo apt install docker-ce
sudo systemctl enable --now docker

echo -e "\033[0;32m╔══════════════════╗\033[0m"
echo -e "\033[0;32m║ Setup kubectl... ║\033[0m"
echo -e "\033[0;32m╚══════════════════╝\033[0m"
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin
sudo kubectl version

echo -e "\033[0;32m╔══════════════╗\033[0m"
echo -e "\033[0;32m║ Setup k3d... ║\033[0m"
echo -e "\033[0;32m╚══════════════╝\033[0m"
sudo wget -q -O — https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

echo -e "\033[0;32m╔════════════════════╗\033[0m"
echo -e "\033[0;32m║ Finishing setup... ║\033[0m"
echo -e "\033[0;32m╚════════════════════╝\033[0m"
sudo apt update

echo -e "\033[0;32m╔══════════╗\033[0m"
echo -e "\033[0;32m║ Finish ! ║\033[0m"
echo -e "\033[0;32m╚══════════╝\033[0m"
rm -rf ./—
