#! /bin/sh

function setup_ssh() {
    echo 'Setup ssh'
    mv ./auth/id_rsa.pub            .ssh/id_rsa.pub
    mv ./auth/id_rsa                .ssh/id_rsa
    cat .ssh/id_rsa.pub >>    .ssh/authorized_keys
    # echo "PasswordAuthentication no" | tee -a /etc/ssh/sshd_config
    # service sshd restart

    chmod 400   .ssh/id_rsa*
    chmod 400   .ssh/authorized_keys
}

setup_ssh

echo "alias k='kubectl'" | tee -a "/home/vagrant/.profile"
chown vagrant:vagrant /home/vagrant/.profile
chmod 644 /home/vagrant/.profile
