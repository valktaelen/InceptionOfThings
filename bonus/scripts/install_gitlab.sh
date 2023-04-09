
apt-get update
apt-get install -y curl openssh-server ca-certificates tzdata perl
echo curl install
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
apt update
echo install gitlab
EXTERNAL_URL="http://192.168.42.110:6969" apt-get install gitlab-ee -y


# GitLab config
# Edit configs
# sudo vim /etc/gitlab/gitlab.rb
# sudo gitlab-ctl reconfigure

# Get root's default password
sudo cat /etc/gitlab/initial_root_password
