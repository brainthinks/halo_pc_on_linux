#!/usr/bin/env bash

function enableSPV3 () {
  rm -rf "$PATH_TO_CE_MAPS"
  cp -R "$PATH_TO_CE_MAPS_SPV3" "PATH_TO_CE_MAPS"
}

function enableMRC () {
  rm -rf "$PATH_TO_CE_MAPS"
  cp -R "$PATH_TO_CE_MAPS_MRC" "PATH_TO_CE_MAPS"
}

function enablePCC () {
  rm -rf "$PATH_TO_CE_MAPS"
  cp -R "$PATH_TO_CE_MAPS_PCC" "PATH_TO_CE_MAPS"
}

function restoreCE () {
  rm -rf "$PATH_TO_CE_MAPS"
  cp -R "$PATH_TO_CE_MAPS_BACKUP" "PATH_TO_CE_MAPS"
}


function cleanStart () {
  # Confirm this script was run in a playonlinux terminal
  if [[ "$PLAYONLINUX" = "" ]]; then
    echo "You must run this from a Playonlinux shell!"
    # @todo - return 1 here instead of exitting
    exit 1
  fi

  # Ensure we always start from the same directory
  cd "$PROJECT_DIR"
}

function mainMenu () {
  cleanStart

  echo ""
  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  Halo PC in Playonlinux Manager                                   ---"
  echo "---                                                                   ---"
  echo "---        Wine Version: $(wine --version)"
  echo "---  Virtual Drive Name: $PREFIXNAME"
  echo "---                                                                   ---"
  echo "---                                                                   ---"
  echo "---  Switch between the different Halo CE Campaign Types!             ---"
  echo "---                                                                   ---"
  echo "---                                                                   ---"
  echo "---  Type in the number that appears in front of the option you want, ---"
  echo "---  then press enter.                                                ---"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
  echo ""

  local options=(\
    "Enable SPV3" \
    "Enable Mos Refined Campaign" \
    "Enable Halo CE Campaign from Halo PC" \
    "Restore Stock Halo CE" \
    "Exit" \
  )

  select option in "${options[@]}"

  do
    case $option in
      "Enable SPV3")
        enableSPV3
        mainMenu
        ;;
      "Enable Mos Refined Campaign")
        enableMRC
        mainMenu
        ;;
      "Enable Halo CE Campaign from Halo PC")
        enablePCC
        mainMenu
        ;;
      "Restore Stock Halo CE")
        restoreCE
        mainMenu
        ;;

      "Exit")
        echo ""
        echo "Bye!"
        echo ""
        exit 0
        ;;
      *)
        echo "You entered an invalid number.  Try Again!"
        ;;
    esac
  done
}


###
### Procedure
###

# Pull in the necessary configurations
source "./config.sh"

# Display the main menu
mainMenu $@