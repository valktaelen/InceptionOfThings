#!/bin/bash

CLUSTER_NAME=mycluster

source scripts/install.sh
install

# ./scripts/install_gitlab.sh

###########

# # Download helm
# sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# sudo kubectl create namespace gitlab

# # Deploy gitlab using helm
# sudo helm repo add gitlab https://charts.gitlab.io/
# sudo helm repo update
# sudo helm upgrade --install gitlab gitlab/gitlab \
#   -n gitlab \
#   -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
#   --set global.hosts.domain=10.11.1.253.nip.io \
#   --set global.hosts.externalIP=10.11.1.253 \
#   --set global.edition=ce \
#   --timeout 600s

# # TODO does not work
# echo 'Gitlab password:'
# kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -ojsonpath='{.data.password}' | base64 --decode ; echo

# sudo kubectl wait --for=condition=available deployments --all -n gitlab
# #########


echo 'Delete cluster'
sudo k3d cluster delete $CLUSTER_NAME
echo 'Create cluster'
sudo k3d cluster create $CLUSTER_NAME #--api-port 6443 -p 8080:80@loadbalancer --agents 2 --wait

# Namespaces
sudo kubectl create namespace argocd
sudo kubectl create namespace dev

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

echo 'Port forward Argo CD'
sudo kubectl port-forward -n argocd svc/argocd-server '8081:443' &
echo 'Port forward Gitlab'
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
