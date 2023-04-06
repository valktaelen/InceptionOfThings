echo "Add k alias [kubectl]"
echo "alias k='kubectl'" | tee -a "/home/vagrant/.profile"
chown vagrant:vagrant /home/vagrant/.profile
chmod 644 /home/vagrant/.profile

echo "install K3S"
current_ip=$(/sbin/ip -o -4 addr list eth1 | awk '{print $4}' | cut -d/ -f1)
echo $current_ip
export INSTALL_K3S_EXEC="--bind-address=${current_ip} --flannel-iface=eth1 --write-kubeconfig-mode 644"
curl -sfL https://get.k3s.io | sh -

echo -n " * Waiting k3s "
while [ ! -f /var/lib/rancher/k3s/server/node-token ]
	do
		sleep 1
        echo -n "."
	done
echo " [ ok ]"

#while true
#do
#	service k3s status
#	if [ $? -eq 0 ]; then sleep 1; break; fi
#	sleep 1
#done
sleep 10
echo "Apply deployments [pod]"
kubectl apply -f /home/vagrant/k3s_cluster/app1.yml
kubectl apply -f /home/vagrant/k3s_cluster/app2.yml
kubectl apply -f /home/vagrant/k3s_cluster/app3.yml

echo "Apply ingress"
kubectl create -f /home/vagrant/k3s_cluster/ingress.yml