#!/bin/bash

JOIN_TOKEN=$(ssh -o StrictHostKeyChecking=no -i /home/vagrant/.ssh/id_rsa vagrant@192.168.42.110 "sudo cat /var/lib/rancher/k3s/server/node-token")

export K3S_URL=https://192.168.42.110:6443
export K3S_TOKEN=$JOIN_TOKEN
export INSTALL_K3S_EXEC="--flannel-iface=eth1"

curl -sfL https://get.k3s.io | sh -
