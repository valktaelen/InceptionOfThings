
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
sudo apt-get install -y postfix
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
sudo EXTERNAL_URL="http://192.168.42.110:6969" apt-get install gitlab-ee


# GitLab config
# Edit configs
# sudo vim /etc/gitlab/gitlab.rb
# sudo gitlab-ctl reconfigure

# Get root's default password
# sudo cat /etc/gitlab/initial_root_password

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
gitlab project create --name "inception" --visibility "public"

cd /home/vagrant/dev
git init
git add .
git commit -m 'initial commit'
git branch -M master
git remote add origin 'http://192.168.42.110:6969/root/inception.git'
git push -u origin master