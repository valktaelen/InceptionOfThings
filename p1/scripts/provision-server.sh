#! /bin/sh

current_ip=$(/sbin/ip -o -4 addr list eth1 | awk '{print $4}' | cut -d/ -f1)

export INSTALL_K3S_EXEC="--bind-address=${current_ip} --flannel-iface=eth1 --write-kubeconfig-mode 644"
curl -sfL https://get.k3s.io | sh -

echo -n " * Waiting k3s "

while [ ! -f /var/lib/rancher/k3s/server/node-token ]
do
	sleep 1
	echo -n "."
done

echo " [ ok ]"
