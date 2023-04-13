#!/bin/bash

# CD
sudo kubectl apply -f confs/config.yml

echo 'Wait app dev ...'
sudo kubectl wait --for=condition=Ready pods --all -n dev

sudo bash << EOF & &>/dev/null
while true ; do
	sudo kubectl port-forward -n dev svc/wil-app 8888:8888 &>/dev/null
	sleep 5
done
EOF
