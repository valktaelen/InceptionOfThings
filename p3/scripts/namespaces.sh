#!/bin/sh

# Setup cluster
k3d cluster create k3d-cluster

# Setup argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Get password
echo -e "\033[0;32m╔══════════════════╗\033[0m"
echo -e "\033[0;32m║ Argocd password: ║\033[0m"
echo -e -n "\033[0;32m║ "
kubectl get secret argocd-initial-admin-secret -n argocd -o yaml | grep "password" | cut -d' ' -f4 | base64 --decode
echo -e " ║\033[0m"
echo -e "\033[0;32m╚══════════════════╝\033[0m"

# Add application to ArgoCD
sudo kubectl apply -f https://raw.githubusercontent.com/Kronx12/IoT_gbaud_part3/master/application.yaml

# Log ips
echo -e "\033[0;32m╔══════════════════╗\033[0m"
echo -e "\033[0;32m║ ArgoCD IP :      ║\033[0m"
echo -e "\033[0;32m║ localhost:8887   ║\033[0m"
echo -e "\033[0;32m╠══════════════════╣\033[0m"
echo -e "\033[0;32m║ Application IP : ║\033[0m"
echo -e -n "\033[0;32m║ "
echo -n $(sudo kubectl get svc -n dev | grep "app42-service" | cut -d' ' -f10)
echo -e ":8888  ║\033[0m"

# Port forward to access
echo -e "\033[0;32m╠══════════════════╣\033[0m"
echo -e "\033[0;32m║ Start listening: ║\033[0m"
echo -e "\033[0;32m╚══════════════════╝\033[0m"
sudo kubectl port-forward -n argocd svc/argocd-server 8887:443
