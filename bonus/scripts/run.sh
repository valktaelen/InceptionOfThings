#!/bin/bash

CLUSTER_NAME=mycluster

source scripts/install.sh
install

echo 'Delete cluster'
sudo k3d cluster delete $CLUSTER_NAME
echo 'Create cluster'
sudo k3d cluster create $CLUSTER_NAME

# Namespaces
sudo kubectl create namespace argocd
sudo kubectl create namespace dev
sudo kubectl create namespace gitlab

# Deploy argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo 'Wait argocd ...'
sleep 42
sudo kubectl wait --for=condition=Ready pods --all -n argocd

echo
echo 'Install gitlab'
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
	--timeout 600s \
	--set global.hosts.externalIP=10.10.10.10 \
	--set global.edition=ce

echo 'wait gitlab'
sleep 42
sudo kubectl wait --for=condition=available deployments --all -n gitlab

sudo kubectl port-forward -n argocd svc/argocd-server 8080:443 1>/dev/null &

sudo kubectl port-forward svc/gitlab-webservice-default --address 10.10.10.10 -n gitlab 8082:8080 1>/dev/null &

echo 'Password argocd: '
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=”{.data.password}” | sed 's/^.//;s/.$//' | base64 -d
echo
echo 'Password gitlab: '
sudo kubectl get secret <name>-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo