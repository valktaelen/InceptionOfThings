# Update packages
sudo apt update
sudo apt upgrade -y

# GitLab dependencies
sudo apt install -y curl vim policycoreutils-python3

# GitLab install
curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo apt install gitlab-ce -y

# Meow
sudo sed -i '32s/.*/external_url "http\:\/\/192.168.42.110"/' /etc/gitlab/gitlab.rb

# GitLab config
# Edit configs
# sudo vim /etc/gitlab/gitlab.rb
sudo gitlab-ctl reconfigure

# Get root's default password
sudo cat /etc/gitlab/initial_root_password

# Change root's default password
sudo gitlab-rake "gitlab:password:reset[root]" << EOF
adminroot
adminroot
EOF

# Change group visibility to allow public repos
# Change group visibility
#    On the top bar, select Menu > Groups and find your project.
#    On the left sidebar, select Settings > General .
#    Expand Naming, visibility .
#    Under Visibility level select either Private , Internal , or Public .
#    Select Save changes .
