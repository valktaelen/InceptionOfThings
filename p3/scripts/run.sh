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

# Deploy argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo 'Wait argocd ...'
sleep 2
sudo kubectl wait --timeout 600s --for=condition=Ready pods --all -n argocd

# CD
sudo kubectl apply -f confs/config.yml

echo 'Wait argocd ...'
sudo kubectl wait --timeout 600s --for=condition=Ready pods --all -n argocd

sudo kubectl port-forward -n argocd svc/argocd-server 8080:443 &

sudo bash << EOF & &>/dev/null
while true ; do
	sudo kubectl port-forward -n dev svc/wil-app 8888:8888 &>/dev/null
	sleep 5
done
EOF

echo 'Password: '
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=”{.data.password}” | sed 's/^.//;s/.$//' | base64 -d
echo
