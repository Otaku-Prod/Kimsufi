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

check_root_sudo()
{
  if [[ "$(id -u)" != 0 ]]
    then
      echo "Vous n'êtes pas root !"
      echo "Tentative en sudo:"
      exec sudo bash $0
    else
      echo "Vous êtes root !"
  fi
}

check_root_sudo

# Début du script

# Check user

#-------------------------------------------------------------------------------
ask_user_name()
{
  echo "Bonjour,"
  read -p "Veuillez saisir le nom d'utilisateur à créer ici : " otaku_script_login
  if [ "$otaku_script_login" = "" ]
    then
      echo "Votre nom d'utilisateur est vide !"
      read -p "Voulez-vous réessayer : O/n (défaut Oui) " re_try
      if [ "$re_try" = "" ] || [ "$re_try" = "O" ] || [ "$re_try" = "o" ]
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
  if [ $(getent passwd $otaku_script_login) ]; 
  then
    REFUSED_NAME=1
  else
    REFUSED_NAME=0
  fi
}
#-------------------------------------------------------------------------------
valid_user_name()
{
  if [ "$REFUSED_NAME" != 1 ]
    then
      VALID_USER=1
    else
      VALID_USER=0
  fi
}
#-------------------------------------------------------------------------------
show_user_name()
{
  case $VALID_USER in
    1)
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
valid_user_name
show_user_name
#-------------------------------------------------------------------------------

# Check group

#-------------------------------------------------------------------------------AFFICHER LA LISTE DES GROUPES AVANT et GERER SI EXISTANT OU NON ETC...
ask_group_name()
{
  read -p "Veuillez entrer votre nom de groupe ici : " otaku_script_group_id
  if [ "$otaku_script_group_id" = "" ]
    then
      echo "Votre nom de groupe est vide !"
      read -p "Voulez-vous réessayer : O/n (défaut Oui) " re_try
      if [ "$re_try" = "" ] || [ "$re_try" = "O" ] || [ "$re_try" = "o" ]
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
check_group_exist()
{
  if [ $(getent group $otaku_script_group_id) ]; 
  then
    EXISTED_GROUP=1
  else
    EXISTED_GROUP=0
  fi
}
#-------------------------------------------------------------------------------
valid_group_name()
{
  if [ "$EXISTED_GROUP" != 1 ]
    then
      echo "Le groupe souhaité n'existe pas !"
      read -p "Voulez-vous continuer quand même ? : O/n (défaut Oui) " next_step
      if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ]
        then
          echo "OK, on continue."
        else
          echo "Vous avez décidé de quitter le script."
          echo "Au revoir."
          exit 0
      fi
    else
      echo "Le groupe souhaité existe !"
      read -p "Voulez-vous continuer ? : O/n (défaut Oui) " next_step
      if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ]
        then
          echo "OK, on continue."
        else
          echo "Vous avez décidé de quitter le script."
          echo "Au revoir."
          exit 0
      fi
  fi
}
#-------------------------------------------------------------------------------
show_group_name()
{
  case $EXISTED_GROUP in
    1)
      echo "L'utilisateur sera ajouté au groupe éxistant "$otaku_script_group_id" après validation.";;
    *)
      echo "Le nom de groupe "$otaku_script_group_id" sera créé après validation.";;
  esac
}
#-------------------------------------------------------------------------------
ask_group_name
check_group_exist
valid_group_name
show_group_name
#-------------------------------------------------------------------------------

# Ajout du Nom Complet ou d'un commentaire

add_full_name()
{
  read -p "Veuillez entrer votre nom complet ici : " otaku_script_fullname
}

add_full_name

# Test du mot de passe

ask_password_user()
{
  echo "Création du mot de passe pour l'utilisateur $otaku_script_login"
  # Rappel -s = cacher le texte saisie, -p = afficher le message "Saisir le mot de passe", -r = pour rendre les "\" visible, -e = pour que "\" soit une commande
  read -s -p "Saisir le mot de passe : `echo $'\n> '`" password_user
  read -s -p "`echo $'\nConfirmation : '` `echo $'\n> '`" confirm_password_user
  
  if [ "$password_user" = "$confirm_password_user" ]
    then
      echo "Le mot de passe est bien confirmé."
    else
      echo "Il y a une erreur dans la saisie du mot de passe, on réessaye."
      ask_password_user
  fi
}

ask_password_user

# Confirmation avant création du compte

red_alert_text() 
{
  printf '\E[31m'; echo "$@"; printf '\E[0m'
}

check_info()
{
  clear
  red_alert_text "UNE PETITE VERIFICATION !"
  #echo -e "\e[1;31mATTENTION : DERNIERE ETAPE AVANT LA CREATION DU COMPTE !"
  #echo -e "\e[1;37mLes informations suivantes sont elles exactes :"
  echo "Identifiant : $otaku_script_login"
  echo "Groupe : $otaku_script_group_id"
  echo "Nom Complet : $otaku_script_fullname"
  read -p "Tout est correct ? : O/n (défaut Oui) " next_step
  if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ]
    then
      echo "OK, on continue."
    else
      echo "Vous avez décidé de quitter le script."
      echo "Au revoir."
      exit 0
  fi
}

check_pass()
{
  echo "Voulez-vous voir et confirmer le mot de passe ? : O/n (défaut Non)" valid_pass
  if [ "$valid_pass" = "O" ] || [ "$valid_pass" = "o" ]
    then
      Mot de passe : $password_user
      echo "Le mot de passe vous convient toujours ? : O/n (défaut Oui)" confirm_pass
      if [ "$confirm_pass" = "" ] || [ "$confirm_pass" = "O" ] || [ "$confirm_pass" = "o" ]
        then
          echo "OK, on continue."
        else
          ask_password_user
      fi
    else
      echo "OK, on continue."
  fi
}

check_info
check_pass

last_step()
{
  clear
  red_alert_text "DERNIERE ETAPE AVANT LA CREATION DU COMPTE !"
  red_alert_text "CTRL + C pour fermer et annuler le script sans impact"
    echo "Dernière étape avant validation du mot de passe"
  read -p "Continuer ? : O/n (défaut Oui) " last_step
  if [ "$last_step" = "" ] || [ "$last_step" = "O" ]
    then
      echo "OK, on continue."
    else
      echo "Vous avez décidé de quitter le script."
      echo "Au revoir."
      exit 0
  fi
}

last_step

# Création du compte

create_user()
{
sudo useradd --create-home --gid "$otaku_script_group_id" --comment "$otaku_script_fullname" "$otaku_script_login"
echo "Le compte est maintenant créé, le dossier de l'utilisateur se trouve dans /home/$otaku_script_login"
if [ "$EXISTED_GROUP" != 1 ]
  then
    groupadd $otaku_script_group_id
    echo "Le groupe "$otaku_script_group_id" a été créé."
  else
    echo "L'utilisateur à rejoint le groupe existant "$otaku_script_group_id"."
fi
}

create_user

# Création du mot de passe

create_password_user()
{
  echo -e "$password_user\n$confirm_password_user" | passwd $otaku_script_login > /dev/null 2>&1
}

create_password_user

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
unset valid_user_name
unset show_user_name
unset ask_group_name
unset check_group_exist
unset valid_group_name
unset show_group_name
unset re_try
unset REFUSED_NAME
unset ACCEPTED_NAME
unset EXISTED_GROUP
unset VALID_USER

# Fin du script