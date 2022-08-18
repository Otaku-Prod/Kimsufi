# A ajouter a chaque fin de ligne quand OK
# > /dev/null 2>&1
#
#

# Variables
## Nom d'utilisateur :
otaku_prod_default_name=kimsufi
## Mot de passe :
otaku_prod_user_password=Otaku-Prod

# Préparation
apt-get -y update
apt-get -y dist-upgrade
groupadd $otaku_prod_default_name
useradd --create-home --gid "$otaku_prod_default_name" --comment "Utilisateur Kimsufi" "$otaku_prod_default_name"
usermod -a -G root,sudo,adm $otaku_prod_default_name
echo -e "$otaku_prod_user_password\n$otaku_prod_user_password" | passwd $otaku_prod_default_name
apt-get -y install perl
deluser --remove-home ubuntu
echo "gpu_mem=16" | tee -a /boot/config.txt

# Docker
apt-get remove docker docker-engine docker.io docker-ce docker-ce-cli containerd containerd.io docker-compose-plugin runc
apt-get -y install ca-certificates curl gnupg lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
chmod a+r /etc/apt/keyrings/docker.gpg
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
usermod -aG docker $otaku_prod_default_name

# Docker-Compose
wget https://github.com/docker/compose/releases/download/v2.7.0/docker-compose-linux-x86_64 && mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose && docker-compose --version

# Redémarrage
reboot