#!/bin/bash

CLUSTER_NAME=mycluster

source scripts/install.sh
install

./scripts/install_gitlab.sh


echo 'Delete cluster'
sudo k3d cluster delete $CLUSTER_NAME
echo 'Create cluster'
sudo k3d cluster create $CLUSTER_NAME #--api-port 6443 -p 8080:80@loadbalancer --agents 2 --wait

# Namespaces
sudo kubectl create namespace argocd
sudo kubectl create namespace dev
sudo kubectl create namespace gitlab

# Deploy argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#sudo kubectl wait --for=condition=Ready pods --all -n argocd

# sudo kubectl -n argocd patch secret argocd-secret \
#   -p '{"stringData": {
#     "admin.password": "$2a$12$xyk8mlgC6l6gWQhTA.LF8uqlX5ng6Ju5BU7zhJ4Sp4VuCzQT7szIm",
#     "admin.passwordMtime": "'$(date +%FT%T%Z)'"
#   }}'

# CD
sudo kubectl apply -f confs/config.yml

# sudo kubectl wait --for=condition=available deployments --all -n gitlab
# sudo kubectl wait --for=condition=Ready pods --all -n argocd

while true ; do
	i=$(sudo kubectl get pod -n argocd 2>/dev/null | grep "1/1" | wc -l)
	if [ $i = 7 ] ; then
		echo "Ready!"
		break
	else
		echo -n "."
		sleep 10
	fi
done

echo 'Port Forward'
sudo kubectl port-forward -n argocd svc/argocd-server '8081:443'
sudo kubectl port-forward svc/gitlab-webservice-default --address 10.11.1.253 -n gitlab 8082:8080 2>&1 >/dev/null &

sudo bash << EOF & &>/dev/null
while true ; do
	sudo kubectl port-forward -n dev svc/wil-app 8888:8888 &>/dev/null
	sleep 5
done
EOF

echo 'Password: '
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=”{.data.password}” | sed 's/^.//;s/.$//' | base64 -d
echo
