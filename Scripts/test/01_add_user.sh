#!/bin/sh

#########################################################################################
# TITRE: 01_add_user.sh
#
# AUTEUR: Otaku-Prod
# VERSION: 1.0
# CREATION: 29/07/2022
# MODIFIE: 29/07/2022
#
# DESCRIPTION: Ajouter un utilisateur avec choix du groupe et création du dossier "home"
#########################################################################################

# Forcing de l'exécution du script en tant que "Root" ou "Sudo"
if [[ "$(id -u)" != 0 ]]
then
  echo "Vous n'êtes pas root !"
  echo "Tentative en sudo:"
  exec sudo bash $0
else
  echo "Vous êtes root !"
  echo "Le script peut continuer..."
fi

# Début du script

# Check user

#-------------------------------------------------------------------------------
ask_user_name()
{
  echo "Bonjour,"
  read -p "Veuillez entrer votre nom d'utilisateur ici : ? " otaku_script_login
  if [ "$otaku_script_login" = "" ]
    then
      echo "Votre nom d'utilisateur est vide !"
      read -p "Voulez-vous réessayer : O/n (défaut Oui) ? " re_try
      if [ "$re_try" = "" ] || [ "$re_try" = "O" ]
        then
          echo "OK, on recommence."
          ask_user_name
        else
          echo "Vous avez décidé de quitter le script."
          echo "Au revoir."
          exit 0
      fi
  fi
}
#-------------------------------------------------------------------------------
check_refused_names()
{
  case $otaku_script_login in
    '_apt'|'abrt'|'adm'|'apache'|'avahi'|'avahi-autoipd'|'backup'|'bin'|'chrony'|'colord'|'dbus'|'deamon'|'dnsmasq'|'docker'|'ftp'|'games'|'gdm'|'geoclue'|'gnat'|'gnome-initial-setup'|'halt'|'hplip'|'http'|'irc'|'kernoops'|'lightdm'|'list'|'lp'|'mail'|'man'|'messagebus'|'nbd'|'news'|'nfsnobody'|'nm-openconnect'|'nobody'|'ntp'|'openvpn'|'operator'|'polkitd'|'proxy'|'pulse'|'qmenu'|'radvd'|'rm-openvpn'|'root'|'rpc'|'rpcuser'|'rtkit'|'saned'|'saslauth'|'setroubleshoot'|'shutdown'|'speech-dispatcher'|'sshd'|'sudo'|'sync'|'sys'|'syslog'|'systemd-bus-proxy'|'systemd-coredump'|'systemd-journal-gateway'|'systemd-journal-remote'|'systemd-journal-upload'|'systemd-network'|'systemd-resolve'|'systemd-timesync'|'tcpdump'|'tss'|'unbound'|'usbmux'|'usbmuxd'|'uupc'|'uuidd'|'whoopsie'|'www-data')
      REFUSED_NAME=0;;
    *)
      REFUSED_NAME=1;;
    esac
}
#-------------------------------------------------------------------------------
check_user_name()
{
  if [ "$REFUSED_NAME" != 0 ]
    then
      if id -u "$otaku_script_login"> /dev/null 2>&1 
        then
          VALID_USER=1
        else
          VALID_USER=0
      fi
  fi
}
#-------------------------------------------------------------------------------
show_user_name()
{
  case $VALID_USER in
    0)
      echo "Le nom d'utilisateur $otaku_script_login est valide."
      echo "Le script peut continuer.";;
    *)
      echo "Désolé, ce script n'accepte pas le nom d'utilisateur $otaku_script_login !"
      echo "Soit vous utilisez un nom d'utilisateur interdit, soit celui-ci existe déjà."
      echo "Veuillez recommencer avec un nom d'utilisateur valide."
      echo "Au revoir."
      exit 0;;
  esac
}
#-------------------------------------------------------------------------------
clear
ask_user_name
check_refused_names
check_user_name
show_user_name
#-------------------------------------------------------------------------------

# Check group

#-------------------------------------------------------------------------------
ask_group_name()
{
  read -p "Veuillez entrer votre nom de groupe ici : ? " otaku_script_group_id
  if [ "$otaku_script_group_id" = "" ]
    then
      echo "Votre nom de groupe est vide !"
      read -p "Voulez-vous réessayer : O/n (défaut Oui) ? " re_try
      if [ "$re_try" = "" ] || [ "$re_try" = "O" ]
        then
          echo "OK, on recommence."
          ask_group_name
        else
          echo "Vous avez décidé de quitter le script."
          echo "Au revoir."
          exit 0
      fi
  fi
}
#-------------------------------------------------------------------------------
check_accepted_names()
{
  case $otaku_script_group_id in
    '_apt'|'abrt'|'adm'|'apache'|'avahi'|'avahi-autoipd'|'backup'|'bin'|'chrony'|'colord'|'dbus'|'deamon'|'dnsmasq'|'docker'|'ftp'|'games'|'gdm'|'geoclue'|'gnat'|'gnome-initial-setup'|'halt'|'hplip'|'http'|'irc'|'kernoops'|'lightdm'|'list'|'lp'|'mail'|'man'|'messagebus'|'nbd'|'news'|'nfsnobody'|'nm-openconnect'|'nobody'|'ntp'|'openvpn'|'operator'|'polkitd'|'proxy'|'pulse'|'qmenu'|'radvd'|'rm-openvpn'|'root'|'rpc'|'rpcgroup'|'rtkit'|'saned'|'saslauth'|'setroubleshoot'|'shutdown'|'speech-dispatcher'|'sshd'|'sudo'|'sync'|'sys'|'syslog'|'systemd-bus-proxy'|'systemd-coredump'|'systemd-journal-gateway'|'systemd-journal-remote'|'systemd-journal-upload'|'systemd-network'|'systemd-resolve'|'systemd-timesync'|'tcpdump'|'tss'|'unbound'|'usbmux'|'usbmuxd'|'uupc'|'uuidd'|'whoopsie'|'www-data')
      ACCEPTED_GROUP=1;;
    *)
      ACCEPTED_GROUP=0;;
    esac
}
#-------------------------------------------------------------------------------
check_group_name()
{
  if [ "$ACCEPTED_GROUP" != 1 ]
    then
      if id -g "$otaku_script_group_id"> /dev/null 2>&1 
        then
          VALID_GROUP=0
        else
          VALID_GROUP=1
      fi
  fi
}
#-------------------------------------------------------------------------------
show_group_name()
{
  case $VALID_GROUP in
    1)
      echo "Le nom de groupe $otaku_script_group_id est valide."
      echo "Le script peut continuer.";;
    *)
      echo "Désolé, ce script n'accepte pas le nom de groupe $otaku_script_group_id !"
      echo "Le groupe ne semble pas exister."
      echo "Veuillez recommencer avec un nom de groupe valide."
      echo "Au revoir."
      exit 0;;
  esac
}
#-------------------------------------------------------------------------------
ask_group_name
check_accepted_names
check_group_name
show_group_name
#-------------------------------------------------------------------------------

# Ajout du Nom Complet ou d'un commentaire

read -p "Veuillez entrer votre nom complet ici : ? " otaku_script_fullname

# Création du compte

sudo useradd --create-home --gid "$otaku_script_group_id" --comment "$otaku_script_fullname" "$otaku_script_login"
echo "Le compte est maintenant créé, le dossier de l'utilisateur se trouve dans /home/$otaku_script_login"

# Création du mot de passe

echo "Veuillez saisir un mot de passe pour l'utilisateur $otaku_script_login"
passwd $otaku_script_login

# Crédit

echo "Merci d'avoir utilisé le script de création de compte."
echo "C'est terminé... Au plaisir de vous revoir !"
echo "Cordialement,"
echo "Otaku-Prod"

# Suppression des variables

unset otaku_script_login
unset otaku_script_fullname
unset otaku_script_group_id
unset ask_user_name
unset check_refused_names
unset check_user_name
unset show_user_name
unset ask_group_name
unset check_accepted_names
unset check_group_name
unset show_group_name
unset re_try
unset REFUSED_NAME
unset ACCEPTED_NAME
unset ACCEPTED_GROUP
unset VALID_USER

# Fin du script