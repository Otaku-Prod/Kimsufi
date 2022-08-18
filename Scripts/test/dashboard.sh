choice_change_user_password()
{
  green_colored_text
  echo "Modification du mot de passe pour l'utilisateur '$otaku_script_login'"
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
      green_colored_text
      echo "Le mot de passe est bien confirmé."
      color_reset
      
    else
      red_colored_text
      echo "`echo $'\n'`"
      echo "Il y a une erreur dans la saisie du mot de passe, on réessaye."
      color_reset
      choice_change_user_password
  fi
}


choice_change_user_settings()
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
      blue_colored_text
      echo "Au revoir."
      color_reset
      exit 0;;
  esac
}



add_group()
{
  usermod -a -G $otaku_script_group_id $otaku_script_login
  green_colored_text
  echo "Le ou les groupes ont bien été ajouté."
  echo "Liste des groupes de l'utilisateur '$otaku_script_login' :"
  id -Gn $otaku_script_login
  color_reset
}

change_group()
{
  green_colored_text
  usermod -g $otaku_script_group_id $otaku_script_login
  echo "Le groupe principal à bien été remplacé."
  echo "L'utilisateur '$otaku_script_login' est maintenant dans le groupe :"
  id -gn $otaku_script_login
  color_reset
}

# A GARDER

valid_edit_user_name()
{
  case $name_exists in
    1)
      clear
      green_colored_text
      echo "L'utilisateur '$otaku_script_login' existe."
      echo "Le script peut continuer."
      color_reset;;
    *)
      clear
      red_colored_text
      echo "Désolé, ce script n'accepte pas le nom d'utilisateur '$otaku_script_login' !"
      echo "L'utilisateur n'existe pas."
      color_reset
      homepage;;
  esac
}


#-------------------------------------------------------------------------------
# Script complet pour la modification d'un utilisateur (changement de mot de passe et du groupe)

edit_user_script()
{
  view_all_users
  ask_user_name
  check_name_exists
  valid_edit_user_name

  choix_edit_user
  valid_edit_choix

  restart_or_quit
}



#-------------------------------------------------------------------------------
# Crédit

credit()
{
  green_colored_text
  echo "Merci d'avoir utilisé le script de création de compte."
  echo "C'est terminé... Au plaisir de vous revoir !"
  echo "Cordialement,"
  echo "Otaku-Prod"
  color_reset
  exit 1
}

#--------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Exécution des fonctions
#--------------------------------------------------------------------------------------------------------------------------------------------------------------#

check_root_sudo

clear

homepage

credit