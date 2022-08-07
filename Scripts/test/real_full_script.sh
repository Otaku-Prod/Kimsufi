# A ajouter a chaque fin de ligne quand OK
 > /dev/null 2>&1

#

# Variables
otaku_prod_default_name=kimsufi
otaku_prod_user_password=Otaku-Prod

# Préparation
sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo groupadd $otaku_prod_default_name
sudo useradd --create-home --gid "$otaku_prod_default_name" --comment "Utilisateur Kimsufi" "$otaku_prod_default_name"
sudo usermod -a -G root,sudo,adm $otaku_prod_default_name
sudo echo -e "$otaku_prod_user_password\n$otaku_prod_user_password" | passwd $otaku_prod_default_name
sudo apt-get -y install perl
sudo deluser --remove-home ubuntu
sudo echo "gpu_mem=16" | sudo tee -a /boot/config.txt

# Docker
sudo apt-get remove docker docker-engine docker.io docker-ce docker-ce-cli containerd containerd.io docker-compose-plugin runc
sudo apt-get -y install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker $otaku_prod_default_name

# Docker-Compose
sudo wget https://github.com/docker/compose/releases/download/v2.7.0/docker-compose-linux-x86_64 && sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose && docker-compose --version

# Redémarrage
sudo reboot