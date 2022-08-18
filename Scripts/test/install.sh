# A ajouter a chaque fin de ligne quand OK
# > /dev/null 2>&1
#
#

# Variables
## Nom d'utilisateur :
otaku_prod_default_name=kimsufi
## Mot de passe :
otaku_prod_user_password=Otaku-Prod

check_admin_rights()
{
  if [[ "$(id -u)" != 0 ]]
    then
      red_colored_text
      echo "Vous n'êtes pas root !"
      blue_colored_text
      echo "Tentative en sudo:"
      color_reset
      exec sudo bash $0
    else
      green_colored_text
      echo "Vous êtes root !"
      color_reset
  fi
}

color_reset()
{
  printf '\E[0m'
}

red_colored_text()
{
  printf '\E[31m'
}

green_colored_text()
{
  printf '\E[32m'
}

blue_colored_text()
{
  printf '\E[34m'
}

credit()
{
  green_colored_text
  echo "Merci d'avoir utilisé l'installation pour Kimsufi."
  echo "C'est terminé... Au plaisir de vous revoir !"
  echo "Cordialement,"
  echo "Otaku-Prod"
  color_reset
  exit 1
}

ubuntu_step()
{
  blue_colored_text
  echo "Préparation d'Ubuntu :"
  apt-get -y update > /dev/null 2>&1
  apt-get -y dist-upgrade > /dev/null 2>&1
  green_colored_text
  echo "Mises à jours terminées."
  groupadd $otaku_prod_default_name
  echo "Le groupe '$otaku_prod_default_name' a été créé."
  useradd --create-home --gid "$otaku_prod_default_name" --comment "Utilisateur Kimsufi" "$otaku_prod_default_name"
  echo "L'utilisateur '$otaku_prod_default_name' a été créé."
  echo "Son répertoire se situe dans '/home/$otaku_prod_default_name'."
  usermod -a -G root,sudo,adm $otaku_prod_default_name
  echo "L'utilisateur a été ajouté aux groupes 'root,sudo,adm'."
  echo -e "$otaku_prod_user_password\n$otaku_prod_user_password" | passwd $otaku_prod_default_name > /dev/null 2>&1
  echo "L'utilisateur '$otaku_prod_default_name' a maintenant le mot de passe par défaut : '$otaku_prod_user_password'."
  apt-get -y install perl wget > /dev/null 2>&1
  echo "Les prérequis : perl et wget ont été installés."
  deluser --remove-home ubuntu > /dev/null 2>&1
  echo "L'utilisateur 'ubuntu' a été supprimé."
  echo "gpu_mem=16" | tee -a /boot/config.txt > /dev/null 2>&1
  echo "Réduction de la mémoire GPU pour optimisation."
}

docker_step()
{
  blue_colored_text
  echo "Installation de Docker :"
  apt-get remove docker docker-engine docker.io docker-ce docker-ce-cli containerd containerd.io docker-compose-plugin runc > /dev/null 2>&1
  green_colored_text
  echo "Les anciennes versions de Docker (si existante) ont été supprimées."
  apt-get -y install ca-certificates curl gnupg lsb-release > /dev/null 2>&1
  echo "Les prérequis : ca-certificates, curl, gnupg, lsb-release ont été installés."
  mkdir -p /etc/apt/keyrings
  echo "Le dossier '/etc/apt/keyrings' a été créé."
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "La clé du dépôt officiel de Docker pour Ubuntu a été récupéré."
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null 2>&1
  echo "Le dépôt Docker a été ajouté à la liste des dépôt."
  chmod a+r /etc/apt/keyrings/docker.gpg
  echo "Ajout des droits de lecture sur la clé."
  apt-get update > /dev/null 2>&1
  apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin > /dev/null 2>&1
  echo "Installation de Docker terminé."
  usermod -aG docker $otaku_prod_default_name
  echo "Ajout de l'utilisateur '$otaku_prod_default_name' au groupe docker."
}

compose_step()
{
  blue_colored_text
  echo "Installation de Docker-Compose :"
  wget https://github.com/docker/compose/releases/download/v2.7.0/docker-compose-linux-x86_64 > /dev/null 2>&1
  mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose > /dev/null 2>&1
  chmod +x /usr/local/bin/docker-compose > /dev/null 2>&1
  docker-compose --version
  echo "Installation terminé."
}

ask_reboot()
{
  blue_colored_text
  echo -n "RECOMMENDE - Redémarrer la Kimsufi maintenant ? "
  color_reset
  echo "O/n (défaut Oui)"
  read -p "> " reboot_script
  if [ "$reboot_script" = "" ] || [ "$reboot_script" = "O" ] || [ "$reboot_script" = "o" ] || [ "$reboot_script" = "oui" ] || [ "$reboot_script" = "yes" ] || [ "$reboot_script" = "y" ] || [ "$reboot_script" = "Y" ]
    then
      reboot
    else
      credit
  fi
}

#--------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Exécution des fonctions
#--------------------------------------------------------------------------------------------------------------------------------------------------------------#

clear

check_admin_rights

ubuntu_step

docker_step

compose_step

ask_reboot