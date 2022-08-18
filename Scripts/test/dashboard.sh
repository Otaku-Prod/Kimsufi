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

red_color_background()
{
  printf '\E[41m'
}

how_to_quit()
{
  red_color_background
  echo "Saisir "0" et valider pour annuler et fermer le script."
  color_reset
}

restart_script()
{
  blue_colored_text
  echo -n "Revenir à la page d'accueil du script ? "
  color_reset
  echo "O/n (défaut Oui)"
  read -p "> " restart_script
  if [ "$restart_script" = "" ] || [ "$restart_script" = "O" ] || [ "$restart_script" = "o" ] || [ "$restart_script" = "oui" ] || [ "$restart_script" = "yes" ] || [ "$restart_script" = "y" ] || [ "$restart_script" = "Y" ]
    then
      clear
      how_to_quit
      homepage
    else
      credit
  fi
}

next_step()
{
  blue_colored_text
  echo -n "Continuer ? "
  color_reset
  echo "O/n (défaut Oui)"
  read -p "> " next_step
  color_reset
  if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
    then
      clear
    else
      clear
      green_colored_text
      echo "Vous avez choisi de ne pas continuer."
      color_reset
      homepage
  fi
}

last_step()
{
  clear
  how_to_quit
  red_text
  echo "DERNIERE ETAPE !"
  echo "Pas de retour arrière possible !"
  next_step
}

credit()
{
  green_colored_text
  echo "Merci d'avoir utilisé le Dashboard pour Kimsufi."
  echo "C'est terminé... Au plaisir de vous revoir !"
  echo "Cordialement,"
  echo "Otaku-Prod"
  color_reset
  exit 1
}

homepage()
{
  blue_colored_text
  echo "Bonjour,"
  echo "Que désirez vous faire :"
  echo -n "Gérer les contenaires ? "
  color_reset
  echo "1"
  blue_colored_text
  echo -n "Gérer Docker ? "
  color_reset
  echo "2"
  blue_colored_text
  echo -n "Gérer la Kimsufi ? "
  color_reset
  echo "3"
  read -p "> " choice_homepage
  choice_homepage
}

choice_homepage()
{
  case $choice_homepage in
    0)
      clear
      credit;;
    1)
      clear
      how_to_quit
      container_management;;
    2)
      clear
      how_to_quit
      docker_management;;
    3)
      clear
      how_to_quit
      kimsufi_management;;
    *)
      clear
      red_colored_text
      echo "Désolé, ce script n'accepte pas votre choix !"
      credit
  esac
}

kimsufi_management()
{
  blue_colored_text
  echo "Bonjour,"
  echo "Que désirez vous faire :"
  echo -n "Voir ? "
  color_reset
  echo "1"
  blue_colored_text
  echo -n "Update ? "
  color_reset
  echo "2"
  blue_colored_text
  echo -n "Restart ? "
  color_reset
  echo "3"
  blue_colored_text
  echo -n "Stop ? "
  color_reset
  echo "4"
  blue_colored_text
  echo -n "Réglages ? "
  color_reset
  echo "5"
  read -p "> " choice_kimsufi_management
  choice_kimsufi_management
}

choice_kimsufi_management()
{
  case $choice_kimsufi_management in
    0)
      clear
      credit;;
    1)
      clear
      how_to_quit
      ;;
    2)
      clear
      how_to_quit
      ;;
    3)
      clear
      how_to_quit
      ;;
    4)
      clear
      how_to_quit
      ;;
    5)
      clear
      how_to_quit
      kimsufi_settings_management;;
    *)
      clear
      red_colored_text
      echo "Désolé, ce script n'accepte pas votre choix !"
      credit
  esac
}

kimsufi_settings_management()
{
  blue_colored_text
  echo "Bonjour,"
  echo "Que désirez vous faire :"
  echo -n "Gérer les utilisateurs ? "
  color_reset
  echo "1"
  blue_colored_text
  echo -n "Gérer les groupes ? "
  color_reset
  echo "2"
  read -p "> " choice_kimsufi_settings_management
  choice_kimsufi_settings_management
}

choice_kimsufi_settings_management()
{
  case $choice_kimsufi_settings_management in
    0)
      clear
      credit;;
    1)
      clear
      how_to_quit
      user_management;;
    2)
      clear
      how_to_quit
      group_management;;
    *)
      clear
      red_colored_text
      echo "Désolé, ce script n'accepte pas votre choix !"
      credit
  esac
}

user_management()
{
  blue_colored_text
  echo "Bonjour,"
  echo "Que désirez vous faire :"
  echo -n "Voir ? "
  color_reset
  echo "1"
  blue_colored_text
  echo -n "Ajouter ? "
  color_reset
  echo "2"
  blue_colored_text
  echo -n "Modifier ? "
  color_reset
  echo "3"
  blue_colored_text
  echo -n "Supprimer ? "
  color_reset
  echo "4"
  read -p "> " choice_user_management
  choice_user_management
}

choice_user_management()
{
  case $choice_user_management in
    0)
      clear
      credit;;
    1)
      clear
      how_to_quit
      view_all_users;;
    2)
      clear
      how_to_quit
      add_user_script;;
    3)
      clear
      how_to_quit
      change_user_settings;;
    4)
      clear
      how_to_quit
      delete_user_script;;
    *)
      clear
      red_colored_text
      echo "Désolé, ce script n'accepte pas votre choix !"
      credit
  esac
}

view_all_users()
{
  clear
  how_to_quit
  green_colored_text
  echo "Voici la liste des utilisateurs :"
  color_reset
  awk -F: 'BEGIN { ORS = " | " } { print $ 1 }' /etc/passwd
  echo "`echo $'\n'`"
  green_colored_text
  echo "Nombre d'utilisateurs existants :"
  color_reset
  cat /etc/passwd | wc -l
  restart_or_quit
}

add_user_script()
{
  ask_view_all_users
  ask_user_name
  check_name_exists
  username_validation

  ask_view_all_groups
  ask_group_name
  check_group_exist
  group_name_validation

  add_full_name

  clear
  how_to_quit
  ask_user_password

  check_info
  check_pass

  last_step

  create_user
  create_user_password

  restart_or_quit
}

ask_view_all_users()
{
  blue_colored_text
  echo -n "Voulez-vous voir tous les utilisateurs existants ? "
  color_reset
  echo "O/n (défaut Oui)"
  read -p "> " next_step
  if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
    then
      green_colored_text
      echo "Voici la liste des utilisateurs :"
      color_reset
      awk -F: 'BEGIN { ORS = " | " } { print $ 1 }' /etc/passwd
      echo "`echo $'\n'`"
  fi
}

ask_user_name()
{
  blue_colored_text
  echo -n "Veuillez saisir le nom d'utilisateur ici : "
  color_reset
  read -p "`echo $'\n> '`" otaku_script_login
  if [ "$otaku_script_login" = "" ]
    then
      red_text
      echo "Votre nom d'utilisateur est vide !"
      blue_colored_text
      echo -n "Voulez-vous réessayer ? "
      color_reset
      echo "O/n (défaut Oui)"
      read -p "> " re_try
      if [ "$re_try" = "" ] || [ "$re_try" = "O" ] || [ "$re_try" = "o" ] || [ "$re_try" = "oui" ] || [ "$re_try" = "yes" ] || [ "$re_try" = "y" ] || [ "$re_try" = "Y" ]
        then
          green_colored_text
          echo "OK, on recommence."
          color_reset
          ask_user_name
        else
          clear
          green_colored_text
          echo "Vous avez choisi de ne pas réessayer."
          color_reset
          homepage
      fi
  fi
}

check_name_exists()
{
  if [ $(getent passwd $otaku_script_login) ]; 
  then
    name_exists=1
  else
    name_exists=0
  fi
}

username_validation()
{
  case $name_exists in
    0)
      clear
      how_to_quit
      green_colored_text
      echo "L'utilisateur '$otaku_script_login' n'existe pas."
      echo "Le script peut continuer."
      color_reset;;
    1)
      clear
      red_colored_text
      echo "Désolé, ce script n'accepte pas le nom d'utilisateur '$otaku_script_login'."
      echo "L'utilisateur est déjà pris !"
      echo "Veuillez recommencer avec un nom d'utilisateur valide."
      color_reset
      homepage;;
  esac
}

ask_view_all_groups()
{
  blue_colored_text
  echo -n "Voulez-vous voir les groupes existants ? "
  color_reset
  echo "O/n (défaut Oui)"
  read -p "> " next_step
  if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
    then
      awk -F: 'BEGIN { ORS = " | " } { print $ 1 }' /etc/group
      echo "`echo $'\n'`"
  fi
}

ask_group_name()
{
  blue_colored_text
  echo -n "Veuillez saisir le nom du groupe ici : "
  color_reset
  read -p "`echo $'\n> '`" otaku_script_group_id
  if [ "$otaku_script_group_id" = "" ]
    then
      red_colored_text
      echo "Votre nom de groupe est vide !"
      blue_colored_text
      echo -n "Voulez-vous réessayer ? "
      color_reset
      echo "O/n (défaut Oui)"
      read -p "> " re_try
      if [ "$re_try" = "" ] || [ "$re_try" = "O" ] || [ "$re_try" = "o" ] || [ "$re_try" = "oui" ] || [ "$re_try" = "yes" ] || [ "$re_try" = "y" ] || [ "$re_try" = "Y" ]
        then
          green_colored_text
          echo "OK, on recommence."
          color_reset
          ask_group_name
        else
          clear
          green_colored_text
          echo "Vous avez choisi de ne pas réessayer."
          color_reset
          homepage
      fi
  fi
}

check_group_exist()
{
  if [ $(getent group $otaku_script_group_id) ]; 
  then
    group_exists=1
  else
    group_exists=0
  fi
}

group_name_validation()
{
  if [ "$group_exists" != 1 ]
    then
      green_colored_text
      echo "Le groupe souhaité n'existe pas !"
      blue_colored_text
      echo -n "Voulez-vous continuer quand même ? "
      color_reset
      echo "O/n (défaut Oui)"
      read -p "> " next_step
      if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
        then
          clear
          how_to_quit
          green_colored_text
          echo "Le nom de groupe '$otaku_script_group_id' sera créé à la fin du script."
          color_reset
        else
          clear
          green_colored_text
          echo "Vous avez choisi de ne pas continuer."
          color_reset
          homepage
      fi
    else
      green_colored_text
      echo "Le groupe souhaité existe !"
      blue_colored_text
      echo -n "Voulez-vous continuer quand même ? "
      color_reset
      echo "O/n (défaut Oui)"
      read -p "> " next_step
      if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
        then
          clear
          how_to_quit
          green_colored_text
          echo "L'utilisateur sera ajouté au groupe éxistant '$otaku_script_group_id' à la fin du script."
          color_reset
        else
          clear
          green_colored_text
          echo "Vous avez choisi de ne pas continuer."
          color_reset
          homepage
      fi
  fi
}

add_full_name()
{
  blue_colored_text
  echo "Veuillez entrer votre nom complet ici : "
  color_reset
  read -p "> " otaku_script_fullname
}

ask_user_password()
{
  green_colored_text
  echo "Création du mot de passe pour l'utilisateur '$otaku_script_login'"
  blue_colored_text
  echo -n "Saisir le mot de passe : "
  color_reset
  read -s -p "`echo $'\n> '`" user_password
  echo "`echo $'\n'`"
  blue_colored_text
  echo -n "Confirmation : "
  color_reset
  read -s -p "`echo $'\n> '`" confirm_user_password
  
  if [ "$user_password" = "$confirm_user_password" ]
    then
      clear
      how_to_quit
      green_colored_text
      echo "Le mot de passe est bien confirmé."
      color_reset
    else
      red_colored_text
      echo "`echo $'\n'`"
      echo "Il y a une erreur dans la saisie du mot de passe, on réessaye."
      color_reset
      ask_user_password
  fi
}

check_info()
{
  green_colored_text
  echo "UNE PETITE VERIFICATION !"
  color_reset
  echo "Identifiant : $otaku_script_login"
  echo "Groupe : $otaku_script_group_id"
  echo "Nom Complet : $otaku_script_fullname"
  blue_colored_text
  echo -n "Tout est correct ? "
  color_reset
  echo "O/n (défaut Oui)"
  read -p "> " next_step
  if [ "$next_step" = "" ] || [ "$next_step" = "O" ] || [ "$next_step" = "o" ] || [ "$next_step" = "oui" ] || [ "$next_step" = "yes" ] || [ "$next_step" = "y" ] || [ "$next_step" = "Y" ]
    then
      clear
      how_to_quit
      green_colored_text
      echo "Les informations sont validées."
      color_reset
    else
      clear
      green_colored_text
      echo "Vous avez déclaré que les informations n'étaient pas correct."
      echo "Le script redémarre."
      color_reset
      homepage
  fi
}

check_pass()
{
  blue_colored_text
  echo -n "Voulez-vous vérifer le mot de passe ? "
  color_reset
  echo "o/N (défaut Non)"
  read -p "> " valid_pass
  color_reset
  if [ "$valid_pass" = "O" ] || [ "$valid_pass" = "o" ] || [ "$valid_pass" = "oui" ] || [ "$valid_pass" = "yes" ] || [ "$valid_pass" = "y" ] || [ "$valid_pass" = "Y" ]
    then
      echo "Mot de passe : $user_password"
      blue_colored_text
      echo -n "Le mot de passe vous convient toujours ? "
      color_reset
      echo "O/n (défaut Oui)"
      read -p "> " confirm_pass
      if [ "$confirm_pass" = "" ] || [ "$confirm_pass" = "O" ] || [ "$confirm_pass" = "o" ] || [ "$confirm_pass" = "oui" ] || [ "$confirm_pass" = "yes" ] || [ "$confirm_pass" = "y" ] || [ "$confirm_pass" = "Y" ]
        then
          clear
          how_to_quit
          green_colored_text
          echo "Le mot de passe a été confirmé."
          color_reset
        else
          ask_user_password
          check_pass
      fi
    else
      clear
      how_to_quit
      green_colored_text
      echo "Le mot de passe a été confirmé."
      color_reset
  fi
}

create_user()
{
  if [ "$group_exists" != 1 ]
    then
      groupadd $otaku_script_group_id
      green_colored_text
      echo "Le groupe '$otaku_script_group_id' a été créé."
      color_reset
    else
      green_colored_text
      echo "L'utilisateur à rejoint le groupe existant '$otaku_script_group_id'."
      color_reset
  fi
  sudo useradd --create-home --gid "$otaku_script_group_id" --comment "$otaku_script_fullname" "$otaku_script_login"
  green_colored_text
  echo "Le compte est maintenant créé, le dossier de l'utilisateur se trouve dans /home/$otaku_script_login"
  color_reset
}

create_user_password()
{
  echo -e "$user_password\n$confirm_user_password" | passwd $otaku_script_login > /dev/null 2>&1
}

user_settings_management()
{
  blue_colored_text
  echo "Bonjour,"
  echo "Que désirez vous faire :"
  echo -n "Changer l'identifiant' ? "
  color_reset
  echo "1"
  blue_colored_text
  echo -n "Changer le full_name ? "
  color_reset
  echo "2"
  blue_colored_text
  echo -n "Changer le mot de passe ? "
  color_reset
  echo "3"
  blue_colored_text
  echo -n "Changer le groupe principal ? "
  color_reset
  echo "4"
  blue_colored_text
  echo -n "Ajouter 1 ou + de groupes ? "
  color_reset
  echo "5"
  read -p "> " choice_user_settings_management
  choice_user_settings_management
}

choice_user_settings_management()
{
  case $choice_user_management in
    0)
      clear
      credit;;
    1)
      clear
      how_to_quit
      ;;
    2)
      clear
      how_to_quit
      ;;
    3)
      clear
      how_to_quit
      ;;
    4)
      clear
      how_to_quit
      ;;
    5)
      clear
      how_to_quit
      ;;
    *)
      clear
      red_colored_text
      echo "Désolé, ce script n'accepte pas votre choix !"
      credit
  esac
}


delete_user_script()
{
  view_all_users
  ask_user_name
  check_name_exists
  valid_edit_user_name

  delete_user

  restart_or_quit
}

delete_user()
{
  deluser --remove-home $otaku_script_login
  green_colored_text
  echo "L'utilisateur '$otaku_script_login' à bien été supprimé."
  color_reset
}

view_all_groups()
{
  how_to_quit
  green_colored_text
  echo "Voici la liste des groupes :"
  color_reset
  awk -F: 'BEGIN { ORS = " | " } { print $ 1 }' /etc/group
  echo "`echo $'\n'`"
  green_colored_text
  echo "Nombre de groupes existants :"
  color_reset
  cat /etc/group | wc -l
  restart_or_quit
}

#--------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Exécution des fonctions
#--------------------------------------------------------------------------------------------------------------------------------------------------------------#

clear

check_admin_rights

how_to_quit

homepage