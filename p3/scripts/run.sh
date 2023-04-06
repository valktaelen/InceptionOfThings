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

# CD
sudo kubectl apply -f confs/config.yml


while [ true ] ; do
	i=$(sudo kubectl get pod -n argocd | grep "1/1" | wc -l)
	if [ $i = 7 ] ; then
		echo "Ready!"
		break
	else
		echo -n "Initializing cluster..."
		sleep 10
	fi
done

sudo kubectl port-forward -n argocd svc/argocd-server 8080:443
sudo kubectl port-forward -n dev svc/app-wil 8888:8888

echo 'Password: '
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=”{.data.password}” | sed 's/^.//;s/.$//' | base64 -d
