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

quit_rappel()
{
  red_background
  echo "CTRL + C pour annuler et fermer à tout moment."
  reset_color
}

#-------------------------------------------------------------------------------
# Gestion des couleurs

red_text() 
{
  printf '\E[31m'
}


green_text() 
{
  printf '\E[32m'
}

blue_text() 
{
  printf '\E[34m'
}

red_background()
{
  printf '\E[41m'
}

reset_color() 
{
  printf '\E[0m'
}

#-------------------------------------------------------------------------------

the_question()
{
  quit_rappel
  blue_text
  echo "Bonjour,"
  echo "Que désirez vous faire :"
  echo -n "Ajouter un utilisateur ? "
  reset_color
  echo "1"
  blue_text
  echo -n "Modifier un utilisateur ? "
  reset_color
  echo "2"
  blue_text
  echo -n "Supprimer un utilisateur ? "
  reset_color
  echo "3"
  blue_text
  echo -n "Voir les utilisateurs existant ? "
  reset_color
  echo "4"
  blue_text
  echo -n "Voir les groupes existant ? "
  reset_color
  echo "5"
  read -p "> " choix
  the_choix
}

the_choix()
{
  case $choix in
    1)
      clear
      quit_rappel
      green_text
      echo "Nous allons ajouter un utilisateur."
      reset_color
      add_user_script;;
    2)
      clear
      quit_rappel
      green_text
      echo "Nous allons modifier un utilisateur."
      reset_color
      edit_user_script;;
    3)
      clear
      quit_rappel
      green_text
      echo "Nous allons supprimer un utilisateur."
      reset_color;;
    4)
      clear
      show_user_list;;
    5)
      clear
      show_group_list;;
    *)
      clear
      red_text
      echo "Désolé, ce script n'accepte pas votre choix !"
      blue_text
      echo "Au revoir."
      reset_color
      exit 0;;
  esac
}

prompt_user_list()
{
  blue_text
  echo -n "Voulez-vous voir les utilisateurs existants ? "
  reset_color
  echo "O/n (défaut Oui)"
  read -p "> " next_step
  if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
    then
      green_text
      echo "Voici la liste des utilisateurs :"
      reset_color
      awk -F: 'BEGIN { ORS = " | " } { print $ 1 }' /etc/passwd
      echo "`echo $'\n'`"
  fi
}

#-------------------------------------------------------------------------------
# Demande du nom d'utilisateur

ask_user_name()
{
  blue_text
  echo -n "Veuillez saisir le nom d'utilisateur à créer ici : "
  reset_color
  read -p "`echo $'\n> '`" otaku_script_login
  if [ "$otaku_script_login" = "" ]
    then
      red_text
      echo "Votre nom d'utilisateur est vide !"
      blue_text
      echo -n "Voulez-vous réessayer ? "
      reset_color
      echo "O/n (défaut Oui)"
      read -p "> " re_try
      if [ "$re_try" = "" ] || [ "$re_try" = "O" ] || [ "$re_try" = "o" ] || [ "$re_try" = "oui" ] || [ "$re_try" = "yes" ] || [ "$re_try" = "y" ] || [ "$re_try" = "Y" ]
        then
          green_text
          echo "OK, on recommence."
          reset_color
          ask_user_name
        else
          clear
          green_text
          echo "Vous avez choisi de ne pas réessayer."
          reset_color
          the_question
      fi
  fi
}

#-------------------------------------------------------------------------------
# Variable pour définir si l'utilisateur est interdit ou pas

check_exist_name()
{
  if [ $(getent passwd $otaku_script_login) ]; 
  then
    EXIST_NAME=1
  else
    EXIST_NAME=0
  fi
}

#-------------------------------------------------------------------------------
# Vérification de l'état de la variable pour l'ajout d'utilisateur

valid_add_user_name()
{
  case $EXIST_NAME in
    0)
      clear
      quit_rappel
      green_text
      echo "L'utilisateur '$otaku_script_login' n'existe pas."
      echo "Le script peut continuer."
      reset_color;;
    *)
      clear
      red_text
      echo "Désolé, ce script n'accepte pas le nom d'utilisateur '$otaku_script_login'."
      echo "L'utilisateur est déjà pris !"
      echo "Veuillez recommencer avec un nom d'utilisateur valide."
      reset_color
      the_question;;
  esac
}

#-------------------------------------------------------------------------------
# Vérification de l'état de la variable pour la modification d'utilisateur

valid_edit_user_name()
{
  case $EXIST_NAME in
    1)
      clear
      quit_rappel
      green_text
      echo "L'utilisateur '$otaku_script_login' existe."
      echo "Le script peut continuer."
      reset_color;;
    *)
      clear
      quit_rappel
      red_text
      echo "Désolé, ce script n'accepte pas le nom d'utilisateur '$otaku_script_login' !"
      echo "L'utilisateur n'existe pas."
      reset_color
      the_question;;
  esac
}

#-------------------------------------------------------------------------------

restart_script()
{
  blue_text
  echo -n "Revenir à la page d'accueil du script ? "
  reset_color
  echo "O/n (défaut Oui)"
  read -p "> " restart_script
  if [ "$restart_script" = "" ] || [ "$restart_script" = "O" ] || [ "$restart_script" = "o" ] || [ "$restart_script" = "oui" ] || [ "$restart_script" = "yes" ] || [ "$restart_script" = "y" ] || [ "$restart_script" = "Y" ]
    then
      clear
      the_question
    else
      credit
  fi
}

show_user_list()
{
  quit_rappel
  green_text
  echo "Voici la liste des utilisateurs :"
  reset_color
  awk -F: 'BEGIN { ORS = " | " } { print $ 1 }' /etc/passwd
  echo "`echo $'\n'`"
  green_text
  echo "Nombre d'utilisateurs existants :"
  reset_color
  cat /etc/passwd | wc -l
  restart_script
}


#-------------------------------------------------------------------------------
# Affiche la liste des groupes

show_group_list()
{
  quit_rappel
  green_text
  echo "Voici la liste des groupes :"
  reset_color
  awk -F: 'BEGIN { ORS = " | " } { print $ 1 }' /etc/group
  echo "`echo $'\n'`"
  green_text
  echo "Nombre de groupes existants :"
  reset_color
  cat /etc/group | wc -l
  restart_script
}

#-------------------------------------------------------------------------------
# Affiche la liste des groupes

prompt_group_list()
{
  blue_text
  echo -n "Voulez-vous voir les groupes existants ? "
  reset_color
  echo "O/n (défaut Oui)"
  read -p "> " next_step
  if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
    then
      awk -F: 'BEGIN { ORS = " | " } { print $ 1 }' /etc/group
      echo "`echo $'\n'`"
  fi
}

#-------------------------------------------------------------------------------
# Demande un nom de groupe

ask_group_name()
{
  blue_text
  echo -n "Veuillez saisir le nom du groupe ici : "
  reset_color
  read -p "`echo $'\n> '`" otaku_script_group_id
  if [ "$otaku_script_group_id" = "" ]
    then
      red_text
      echo "Votre nom de groupe est vide !"
      blue_text
      echo -n "Voulez-vous réessayer ? "
      reset_color
      echo "O/n (défaut Oui)"
      read -p "> " re_try
      if [ "$re_try" = "" ] || [ "$re_try" = "O" ] || [ "$re_try" = "o" ] || [ "$re_try" = "oui" ] || [ "$re_try" = "yes" ] || [ "$re_try" = "y" ] || [ "$re_try" = "Y" ]
        then
          green_text
          echo "OK, on recommence."
          reset_color
          ask_group_name
        else
          clear
          green_text
          echo "Vous avez choisi de ne pas réessayer."
          reset_color
          the_question
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
      green_text
      echo "Le groupe souhaité n'existe pas !"
      blue_text
      echo -n "Voulez-vous continuer quand même ? "
      reset_color
      echo "O/n (défaut Oui)"
      read -p "> " next_step
      if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
        then
          clear
          quit_rappel
          green_text
          echo "Le nom de groupe '$otaku_script_group_id' sera créé à la fin du script."
          reset_color
        else
          clear
          green_text
          echo "Vous avez choisi de ne pas continuer."
          reset_color
          the_question
      fi
    else
      green_text
      echo "Le groupe souhaité existe !"
      blue_text
      echo -n "Voulez-vous continuer quand même ? "
      reset_color
      echo "O/n (défaut Oui)"
      read -p "> " next_step
      if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
        then
          clear
          quit_rappel
          green_text
          echo "L'utilisateur sera ajouté au groupe éxistant '$otaku_script_group_id' à la fin du script."
          reset_color
        else
          clear
          green_text
          echo "Vous avez choisi de ne pas continuer."
          reset_color
          the_question
      fi
  fi
}

valid_group_edit()
{
  if [ "$EXISTED_GROUP" != 1 ]
    then
      green_text
      echo "Le groupe souhaité n'existe pas !"
      reset_color
      the_question      
    else
      green_text
      echo "Le groupe souhaité existe !"
      reset_color
      blue_text
      echo -n "Voulez-vous continuer quand même ? "
      reset_color
      echo "O/n (défaut Oui)"
      read -p "> " next_step
      if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
        then
          clear
          quit_rappel
          green_text
          echo "L'utilisateur sera ajouté au groupe éxistant '$otaku_script_group_id' à la fin du script."
          reset_color
        else
          clear
          green_text
          echo "Vous avez choisi de ne pas continuer."
          reset_color
          the_question
      fi
  fi
}

#-------------------------------------------------------------------------------
# Ajout du Nom Complet ou d'un commentaire

add_full_name()
{
  blue_text
  echo "Veuillez entrer votre nom complet ici : "
  reset_color
  read -p "> " otaku_script_fullname
}

#-------------------------------------------------------------------------------
# Demande et test du mot de passe

ask_password_user()
{
  green_text
  echo "Création du mot de passe pour l'utilisateur '$otaku_script_login'"
  blue_text
  echo -n "Saisir le mot de passe : "
  reset_color
  read -s -p "`echo $'\n> '`" password_user
  echo "`echo $'\n'`"
  blue_text
  echo -n "Confirmation : "
  reset_color
  read -s -p "`echo $'\n> '`" confirm_password_user
  
  if [ "$password_user" = "$confirm_password_user" ]
    then
      clear
      quit_rappel
      green_text
      echo "Le mot de passe est bien confirmé."
      reset_color
    else
      red_text
      echo "`echo $'\n'`"
      echo "Il y a une erreur dans la saisie du mot de passe, on réessaye."
      reset_color
      ask_password_user
  fi
}

#-------------------------------------------------------------------------------
# Vérification des informations non sensibles avant création du compte

check_info()
{
  green_text
  echo "UNE PETITE VERIFICATION !"
  reset_color
  echo "Identifiant : $otaku_script_login"
  echo "Groupe : $otaku_script_group_id"
  echo "Nom Complet : $otaku_script_fullname"
  blue_text
  echo -n "Tout est correct ? "
  reset_color
  echo "O/n (défaut Oui)"
  read -p "> " next_step
  if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
    then
      clear
      quit_rappel
      green_text
      echo "Les informations sont validées."
      reset_color
    else
      clear
      green_text
      echo "Vous avez déclaré que les informations n'étaient pas correct."
      echo "Le script redémarre."
      reset_color
      the_question
  fi
}

#-------------------------------------------------------------------------------
# Vérification des informations sensibles avant création du compte

check_pass()
{
  blue_text
  echo -n "Voulez-vous vérifer le mot de passe ? "
  reset_color
  echo "o/N (défaut Non)"
  read -p "> " valid_pass
  reset_color
  if [ "$valid_pass" = "O" ] || [ "$valid_pass" = "o" ] || [ "$valid_pass" = "oui" ] || [ "$valid_pass" = "yes" ] || [ "$valid_pass" = "y" ] || [ "$valid_pass" = "Y" ]
    then
      echo "Mot de passe : $password_user"
      blue_text
      echo -n "Le mot de passe vous convient toujours ? "
      reset_color
      echo "O/n (défaut Oui)"
      read -p "> " confirm_pass
      if [ "$confirm_pass" = "" ] || [ "$confirm_pass" = "O" ] || [ "$confirm_pass" = "o" ] || [ "$confirm_pass" = "oui" ] || [ "$confirm_pass" = "yes" ] || [ "$confirm_pass" = "y" ] || [ "$confirm_pass" = "Y" ]
        then
          clear
          quit_rappel
          green_text
          echo "Le mot de passe a été confirmé."
          reset_color
        else
          ask_password_user
          check_pass
      fi
    else
      clear
      quit_rappel
      green_text
      echo "Le mot de passe a été confirmé."
      reset_color
  fi
}

#-------------------------------------------------------------------------------
# Dernière chance de quitter le script sans problème

last_step()
{
  red_text
  echo "DERNIERE ETAPE AVANT LA CREATION DU COMPTE !"
  echo "Le compte va être créé, pas de retour arrière possible !"
  blue_text
  echo -n "Continuer ? "
  reset_color
  echo "O/n (défaut Oui)"
  read -p "> " last_step
  reset_color
  if [ "$last_step" = "" ] || [ "$last_step" = "O" ] || [ "$last_step" = "o" ] || [ "$last_step" = "oui" ] || [ "$last_step" = "yes" ] || [ "$last_step" = "y" ] || [ "$last_step" = "Y" ]
    then
      clear
    else
      clear
      green_text
      echo "Vous avez choisi de ne pas continuer."
      reset_color
      the_question
  fi
}

#-------------------------------------------------------------------------------
# Création du compte

create_user()
{
  if [ "$EXISTED_GROUP" != 1 ]
    then
      groupadd $otaku_script_group_id
      green_text
      echo "Le groupe '$otaku_script_group_id' a été créé."
      reset_color
    else
      green_text
      echo "L'utilisateur à rejoint le groupe existant '$otaku_script_group_id'."
      reset_color
  fi
  sudo useradd --create-home --gid "$otaku_script_group_id" --comment "$otaku_script_fullname" "$otaku_script_login"
  green_text
  echo "Le compte est maintenant créé, le dossier de l'utilisateur se trouve dans /home/$otaku_script_login"
  reset_color
}

#-------------------------------------------------------------------------------
# Création du mot de passe

create_password_user()
{
  echo -e "$password_user\n$confirm_password_user" | passwd $otaku_script_login > /dev/null 2>&1
}

add_group()
{
  usermod -a -G $otaku_script_group_id $otaku_script_login
  echo "ok"
}

change_group()
{
  usermod -g $otaku_script_group_id $otaku_script_login
  echo "ok"
}

#-------------------------------------------------------------------------------
# Choix de l'édition de l'utilisateur

choix_edit_user()
{
  clear
  quit_rappel
  blue_text
  echo "Que voulez vous faire avec $otaku_script_login !"
  echo -n "Changer le mot de passe ? "
  reset_color
  echo "1"
  blue_text
  echo -n "Changer le groupe actuel ? "
  reset_color
  echo "2"
  blue_text
  echo -n "Ajouter un ou plusieurs groupes ? "
  reset_color
  echo "3"
  read -p "> " choix
  valid_edit_choix
}

#-------------------------------------------------------------------------------

valid_edit_choix()
{
  case $choix in
    1)
      clear
      quit_rappel
      green_text
      echo "Nous allons changer le mot de passe."
      reset_color
      ask_password_user
      check_pass
      the_question;;
    2)
      clear
      quit_rappel
      green_text
      echo "Nous allons changer le groupe principal (efface celui existant)."
      reset_color
      prompt_group_list
      ask_group_name
      check_group_exist
      change_group
      the_question;;
    3)
      clear
      quit_rappel
      green_text
      echo "Nous allons ajouter un ou plusieurs groupes (cela n'efface pas les groupes déjà présents)."
      reset_color
      prompt_group_list
      ask_group_name
      check_group_exist
      add_group
      the_question;;
    *)
      clear
      red_text
      echo "Désolé, ce script n'accepte pas le votre choix !"
      reset_color
      echo "Au revoir."
      exit 0;;
  esac
}

#-------------------------------------------------------------------------------
# Script complet pour ajouter un utilisateur (création d'un utilisateur avec nom complet, dossier 'home', choix des groupes et du mot de passe)

add_user_script()
{
  prompt_user_list
  ask_user_name
  check_exist_name
  valid_add_user_name

  prompt_group_list
  ask_group_name
  check_group_exist
  valid_group_name

  add_full_name

  clear
  quit_rappel
  ask_password_user

  check_info
  check_pass
  last_step

  create_user
  create_password_user
  sleep 5
  the_question
}

#-------------------------------------------------------------------------------
# Script complet pour la modification d'un utilisateur (changement de mot de passe et du groupe)

edit_user_script()
{
  prompt_user_list
  ask_user_name
  check_exist_name
  valid_edit_user_name

  choix_edit_user
  valid_edit_choix
  
  prompt_group_list
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
}

#-------------------------------------------------------------------------------
# Crédit

credit()
{
  green_text
  echo "Merci d'avoir utilisé le script de création de compte."
  echo "C'est terminé... Au plaisir de vous revoir !"
  echo "Cordialement,"
  echo "Otaku-Prod"
  reset_color
  exit 1
}

#--------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Exécution des fonctions
#--------------------------------------------------------------------------------------------------------------------------------------------------------------#

check_root_sudo

clear

the_question

# faire un if ici sinon ca senchaine
#> Creer une fonction avec un if et faire appel a cette fonction en dessous en remplacement
add_user_script
edit_user_script

credit