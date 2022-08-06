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
  echo "Que désirez vous faire ?" | reset_color | echo "test"
  read -p "Ajouter un utilisateur ? 1 `echo $'\nModifier un utilisateur ? 2 '` `echo $'\nSupprimer un utilisateur ? 3 '` `echo $'\nVoir les utilisateurs existant ? 4 '` `echo $'\nVoir les groupes existant ? 5 '` `echo $'\n> '`" choix
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
      green_text
      ;;
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
      reset_color
      echo "Au revoir."
      exit 0;;
  esac
}

#-------------------------------------------------------------------------------
# Demande du nom d'utilisateur

ask_user_name()
{
  read -p "Veuillez saisir le nom d'utilisateur à créer ici : `echo $'\n> '`" otaku_script_login
  if [ "$otaku_script_login" = "" ]
    then
      red_text
      echo "Votre nom d'utilisateur est vide !"
      reset_color
      read -p "Voulez-vous réessayer : O/n (défaut Oui) " re_try
      if [ "$re_try" = "" ] || [ "$re_try" = "O" ] || [ "$re_try" = "o" ] || [ "$re_try" = "oui" ] || [ "$re_try" = "yes" ] || [ "$re_try" = "y" ] || [ "$re_try" = "Y" ]
        then
          green_text
          echo "OK, on recommence."
          reset_color
          ask_user_name
        else
          clear
          echo "Vous avez choisi de ne pas réessayer."
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

show_user_list()
{
  green_text
  echo "Voici la liste des utilisateurs :"
  reset_color
  awk -F: 'BEGIN { ORS = " | " } { print $ 1 }' /etc/passwd
  echo "`echo $'\n'`"
  green_text
  echo "Nombre d'utilisateurs existants :"
  cat /etc/passwd | wc -l
  reset_color
  the_question
}


#-------------------------------------------------------------------------------
# Affiche la liste des groupes

prompt_user_name()
{
  read -p "Voulez-vous voir les utilisateurs existants ? : O/n (défaut Oui) " next_step
  if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
    then
      green_text
      echo "Voici la liste des utilisateurs :"
      reset_color
      awk -F: 'BEGIN { ORS = " | " } { print $ 1 }' /etc/passwd
      echo "`echo $'\n'`"
  fi
}

show_group_list()
{
  green_text
  echo "Voici la liste des groupes :"
  reset_color
  awk -F: 'BEGIN { ORS = " | " } { print $ 1 }' /etc/group
  echo "`echo $'\n'`"
  green_text
  echo "Nombre de groupes existants :"
  cat /etc/group | wc -l
  reset_color
  the_question
}

#-------------------------------------------------------------------------------
# Affiche la liste des groupes

prompt_group_name()
{
  read -p "Voulez-vous voir les groupes existants ? : O/n (défaut Oui) " next_step
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
  read -p "Veuillez entrer votre nom de groupe ici : " otaku_script_group_id
  if [ "$otaku_script_group_id" = "" ]
    then
      red_text
      echo "Votre nom de groupe est vide !"
      reset_color
      read -p "Voulez-vous réessayer : O/n (défaut Oui) " re_try
      if [ "$re_try" = "" ] || [ "$re_try" = "O" ] || [ "$re_try" = "o" ] || [ "$re_try" = "oui" ] || [ "$re_try" = "yes" ] || [ "$re_try" = "y" ] || [ "$re_try" = "Y" ]
        then
          echo "OK, on recommence."
          ask_group_name
        else
          clear
          echo "Vous avez choisi de ne pas réessayer."
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
      red_text
      echo "Le groupe souhaité n'existe pas !"
      reset_color
      read -p "Voulez-vous continuer quand même ? : O/n (défaut Oui) " next_step
      if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
        then
          clear
          quit_rappel
          green_text
          echo "Le nom de groupe '$otaku_script_group_id' sera créé après validation."
          reset_color
        else
          clear
          echo "Vous avez choisi de ne pas continuer."
          the_question
      fi
    else
      green_text
      echo "Le groupe souhaité existe !"
      reset_color
      read -p "Voulez-vous continuer quand même ? : O/n (défaut Oui) " next_step
      if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
        then
          clear
          quit_rappel
          green_text
          echo "L'utilisateur sera ajouté au groupe éxistant '$otaku_script_group_id' après validation."
          reset_color
        else
          clear
          echo "Vous avez choisi de ne pas continuer."
          the_question
      fi
  fi
}

valid_group_edit()
{
  if [ "$EXISTED_GROUP" != 1 ]
    then
      red_text
      echo "Le groupe souhaité n'existe pas !"
      reset_color
      the_question      
    else
      green_text
      echo "Le groupe souhaité existe !"
      reset_color
      read -p "Voulez-vous continuer quand même ? : O/n (défaut Oui) " next_step
      if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
        then
          clear
          quit_rappel
          green_text
          echo "L'utilisateur sera ajouté au groupe éxistant '$otaku_script_group_id' après validation."
          reset_color
        else
          clear
          echo "Vous avez choisi de ne pas continuer."
          the_question
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
      clear
      quit_rappel
      green_text
      echo "Le mot de passe est bien confirmé."
      reset_color
    else
      clear
      quit_rappel
      red_text
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
  read -p "Tout est correct ? : O/n (défaut Oui) " next_step
  if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
    then
      clear
      quit_rappel
      green_text
      echo "Les informations sont validées."
      reset_color
    else
      clear
      echo "Vous avez déclaré que les informations n'étaient pas correct."
      echo "Le script redémarre."
      the_question
  fi
}

#-------------------------------------------------------------------------------
# Vérification des informations sensibles avant création du compte

check_pass()
{
  read -p "Voulez-vous vérifer le mot de passe ? : O/n (défaut Non)" valid_pass
  reset_color
  if [ "$valid_pass" = "O" ] || [ "$valid_pass" = "o" ] || [ "$valid_pass" = "oui" ] || [ "$valid_pass" = "yes" ] || [ "$valid_pass" = "y" ] || [ "$valid_pass" = "Y" ]
    then
      echo "Mot de passe : $password_user"
      read -p "Le mot de passe vous convient toujours ? : O/n (défaut Oui)" confirm_pass
      if [ "$confirm_pass" = "" ] || [ "$confirm_pass" = "O" ] || [ "$confirm_pass" = "o" ] || [ "$confirm_pass" = "oui" ] || [ "$confirm_pass" = "yes" ] || [ "$confirm_pass" = "y" ] || [ "$confirm_pass" = "Y" ]
        then
          clear
          quit_rappel
          echo "OK, on continue."
        else
          ask_password_user
      fi
    else
      clear
      quit_rappel
      echo "OK, on continue."
  fi
}

#-------------------------------------------------------------------------------
# Dernière chance de quitter le script sans problème

last_step()
{
  clear
  quit_rappel
  red_text
  echo "DERNIERE ETAPE AVANT LA CREATION DU COMPTE !"
  echo "Le compte va être créé, pas de retour arrière possible !"
  reset_color
  read -p "Continuer ? : O/n (défaut Oui) " last_step
  if [ "$last_step" = "" ] || [ "$last_step" = "O" ] || [ "$last_step" = "o" ] || [ "$last_step" = "oui" ] || [ "$last_step" = "yes" ] || [ "$last_step" = "y" ] || [ "$last_step" = "Y" ]
    then
      clear
      quit_rappel
    else
      clear
      echo "Vous avez choisi de ne pas continuer."
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
  echo "Que voulez vous faire avec $otaku_script_login !"
  read -p "Changer le mot de passe ? 1 `echo $'\nChanger le groupe actuel ? 2 '` `echo $'\nAjouter un ou plusieurs groupes ? 3 '` `echo $'\n> '`" choix
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
      prompt_group_name
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
      prompt_group_name
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
  prompt_user_name
  ask_user_name
  check_exist_name
  valid_add_user_name

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
  sleep 5
  the_question
}

#-------------------------------------------------------------------------------
# Script complet pour la modification d'un utilisateur (changement de mot de passe et du groupe)

edit_user_script()
{
  prompt_user_name
  ask_user_name
  check_exist_name
  valid_edit_user_name

  choix_edit_user
  valid_edit_choix
  
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
}

#--------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Exécution des fonctions
#--------------------------------------------------------------------------------------------------------------------------------------------------------------#

check_root_sudo

clear

the_question

# faire un if ici sinon ca senchaine
add_user_script
edit_user_script

credit