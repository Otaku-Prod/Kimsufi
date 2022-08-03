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

#--------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Création des fonctions
#--------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------
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

#-------------------------------------------------------------------------------
# Gestion des couleurs

red_text() 
{
  printf '\E[31m'; echo "$@"; printf '\E[0m'
}

green_text() 
{
  printf '\E[32m'; echo "$@"; printf '\E[0m'
}

#-------------------------------------------------------------------------------
# Demande du nom d'utilisateur

ask_user_name()
{
  echo "Bonjour,"
  read -p "Veuillez saisir le nom d'utilisateur à créer ici : " otaku_script_login
  if [ "$otaku_script_login" = "" ]
    then
      echo "Votre nom d'utilisateur est vide !"
      read -p "Voulez-vous réessayer : O/n (défaut Oui) " re_try
      if [ "$re_try" = "" ] || [ "$re_try" = "O" ] || [ "$re_try" = "o" ] || [ "$re_try" = "oui" ] || [ "$re_try" = "yes" ] || [ "$re_try" = "y" ] || [ "$re_try" = "Y" ]
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
# Variable pour définir si l'utilisateur est interdit ou pas

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
# Vérification de l'état de la variable

valid_user_name()
{
  case $REFUSED_NAME in
    0)
      echo "Le nom d'utilisateur '$otaku_script_login' est valide."
      echo "Le script peut continuer.";;
    *)
      echo "Désolé, ce script n'accepte pas le nom d'utilisateur '$otaku_script_login' !"
      echo "Soit vous utilisez un nom d'utilisateur interdit, soit celui-ci existe déjà."
      echo "Veuillez recommencer avec un nom d'utilisateur valide."
      echo "Au revoir."
      exit 0;;
  esac
}

#-------------------------------------------------------------------------------
# Affiche la liste des groupes

prompt_group_name()
{
  read -p "Voulez-vous voir les groupes existants ? : O/n (défaut Oui) " next_step
  if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
    then
      cat /etc/group | awk -F: '{print $ 1}'
    else
      echo "Ok, on passe."
  fi
}

#-------------------------------------------------------------------------------
# Demande un nom de groupe

ask_group_name()
{
  read -p "Veuillez entrer votre nom de groupe ici : " otaku_script_group_id
  if [ "$otaku_script_group_id" = "" ]
    then
      echo "Votre nom de groupe est vide !"
      read -p "Voulez-vous réessayer : O/n (défaut Oui) " re_try
      if [ "$re_try" = "" ] || [ "$re_try" = "O" ] || [ "$re_try" = "o" ] || [ "$re_try" = "oui" ] || [ "$re_try" = "yes" ] || [ "$re_try" = "y" ] || [ "$re_try" = "Y" ]
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
# Variable pour définir si le groupe existe ou non

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
# Vérification de l'état de la variable

valid_group_name()
{
  if [ "$EXISTED_GROUP" != 1 ]
    then
      echo "Le groupe souhaité n'existe pas !"
      read -p "Voulez-vous continuer quand même ? : O/n (défaut Oui) " next_step
      if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
        then
          echo "OK, on continue."
          echo "Le nom de groupe '$otaku_script_group_id' sera créé après validation."
        else
          echo "Vous avez décidé de quitter le script."
          echo "Au revoir."
          exit 0
      fi
    else
      echo "Le groupe souhaité existe !"
      read -p "Voulez-vous continuer quand même ? : O/n (défaut Oui) " next_step
      if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
        then
          echo "OK, on continue."
          echo "L'utilisateur sera ajouté au groupe éxistant '$otaku_script_group_id' après validation."
        else
          echo "Vous avez décidé de quitter le script."
          echo "Au revoir."
          exit 0
      fi
  fi
}

#-------------------------------------------------------------------------------
# Ajout du Nom Complet ou d'un commentaire

add_full_name()
{
  read -p "Veuillez entrer votre nom complet ici : " otaku_script_fullname
}

#-------------------------------------------------------------------------------
# Demande et test du mot de passe

ask_password_user()
{
  echo "Création du mot de passe pour l'utilisateur '$otaku_script_login'"
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

#-------------------------------------------------------------------------------
# Vérification des informations non sensibles avant création du compte

check_info()
{
  clear
  red_text "UNE PETITE VERIFICATION !"
  #echo -e "\e[1;31mATTENTION : DERNIERE ETAPE AVANT LA CREATION DU COMPTE !"
  #echo -e "\e[1;37mLes informations suivantes sont elles exactes :"
  echo "Identifiant : $otaku_script_login"
  echo "Groupe : $otaku_script_group_id"
  echo "Nom Complet : $otaku_script_fullname"
  read -p "Tout est correct ? : O/n (défaut Oui) " next_step
  if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
    then
      echo "OK, on continue."
    else
      echo "Vous avez décidé de quitter le script."
      echo "Au revoir."
      exit 0
  fi
}

#-------------------------------------------------------------------------------
# Vérification des informations sensibles avant création du compte

check_pass()
{
  read -p "Voulez-vous voir et confirmer le mot de passe ? : O/n (défaut Non)" valid_pass
  if [ "$valid_pass" = "O" ] || [ "$valid_pass" = "o" ] || [ "$valid_pass" = "oui" ] || [ "$valid_pass" = "yes" ] || [ "$valid_pass" = "y" ] || [ "$valid_pass" = "Y" ]
    then
      echo "Mot de passe : $password_user"
      read -p "Le mot de passe vous convient toujours ? : O/n (défaut Oui)" confirm_pass
      if [ "$confirm_pass" = "" ] || [ "$confirm_pass" = "O" ] || [ "$confirm_pass" = "o" ] || [ "$confirm_pass" = "oui" ] || [ "$confirm_pass" = "yes" ] || [ "$confirm_pass" = "y" ] || [ "$confirm_pass" = "Y" ]
        then
          echo "OK, on continue."
        else
          ask_password_user
      fi
    else
      echo "OK, on continue."
  fi
}

#-------------------------------------------------------------------------------
# Dernière chance de quitter le script sans problème

last_step()
{
  clear
  red_text "DERNIERE ETAPE AVANT LA CREATION DU COMPTE !"
  red_text "CTRL + C pour fermer et annuler le script sans impact"
  echo "Le compte va être créé, pas de retour arrière possible !"
  read -p "Continuer ? : O/n (défaut Oui) " last_step
  if [ "$last_step" = "" ] || [ "$last_step" = "O" ] || [ "$last_step" = "o" ] || [ "$last_step" = "oui" ] || [ "$last_step" = "yes" ] || [ "$last_step" = "y" ] || [ "$last_step" = "Y" ]
    then
      echo "OK, on continue."
    else
      echo "Vous avez décidé de quitter le script."
      echo "Au revoir."
      exit 0
  fi
}

#-------------------------------------------------------------------------------
# Création du compte

create_user()
{
  if [ "$EXISTED_GROUP" != 1 ]
    then
      groupadd $otaku_script_group_id
      echo "Le groupe '$otaku_script_group_id' a été créé."
    else
      echo "L'utilisateur à rejoint le groupe existant '$otaku_script_group_id'."
  fi
  sudo useradd --create-home --gid "$otaku_script_group_id" --comment "$otaku_script_fullname" "$otaku_script_login"
  echo "Le compte est maintenant créé, le dossier de l'utilisateur se trouve dans /home/$otaku_script_login"
}

#-------------------------------------------------------------------------------
# Création du mot de passe

create_password_user()
{
  echo -e "$password_user\n$confirm_password_user" | passwd $otaku_script_login > /dev/null 2>&1
}

#-------------------------------------------------------------------------------
# Crédit

credit()
{
  green_text "Merci d'avoir utilisé le script de création de compte."
  green_text "C'est terminé... Au plaisir de vous revoir !"
  green_text "Cordialement,"
  green_text "Otaku-Prod"
}

#--------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Exécution des fonctions
#--------------------------------------------------------------------------------------------------------------------------------------------------------------#

check_root_sudo

clear

ask_user_name
check_refused_names
valid_user_name

prompt_group_name
ask_group_name
check_group_exist
valid_group_name

add_full_name

ask_password_user

check_info
check_pass
last_step

create_user
create_password_user

credit