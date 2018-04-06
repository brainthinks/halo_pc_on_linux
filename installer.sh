#!/usr/bin/env bash

# @todos:
# implement combustion!
# don't require the user to type "Yes" to override registry settings
# untar the iso rather than mounting it
# create log files to track individual installers if they requireUserToContinue
# download as many of the files as possible
# configure wine? desktop, cmst, etc
# create shortcuts

###
### Helpers
###

# Is the command available to be executed?
#
# @param $1 command
#   The command
function dependencyExists () {
  if [[ $(which "$1" | wc -l) = 1 ]]; then
    return 0
  else
    return 1
  fi
}

# Does the file exist?
#
# @param $1 pathToFile
#   The path to the file to check the existence of
function fileExists () {
  if [[ -f "$1" ]]; then
    return 0
  else
    return 1
  fi
}

# Ensure winetricks is installed.  If a locally installed version is found, it
# will be used.  If a locally installed version is not found, the latest version
# of winetricks will be downloaded from github and used.
function detectWinetricks () {
  dependencyExists winetricks
  if [[ "$?" = "0" ]]; then
    WINETRICKS=winetricks
    echo "found installed winetricks"
    return 0
  fi

  fileExists "./winetricks"
  if [[ "$?" = "0" ]]; then
    echo "found local winetricks..."
    WINETRICKS=./winetricks
    return 0
  fi

  echo "could not find winetricks - downloading latest..."
  wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
  chmod +x winetricks
  WINETRICKS=./winetricks
  echo "winetricks downloaded..."
  return 0
}

function cleanStart () {
  # Confirm this script was run in a playonlinux terminal
  if [[ "$PLAYONLINUX" = "" ]]; then
    echo "You must run this from a Playonlinux shell!"
    # @todo - return 1 here instead of exitting
    exit 1
  fi

  # Delete the tmp directory we use, then re-initialize it
  rm -rf "$TMP_DIR"
  mkdir -p "$TMP_DIR"

  # Ensure we always start from the same directory
  cd "$STARTING_PATH"
}


###
### Installers
###

# Install all necessary dependencies to be able to run the Windows Halo
# installers.
#
# @todo - can we detect whether or not these have already been installed?
function installDependencies () {
  # A prerequisite for dotnet35
  $WINETRICKS -q msxml3

  # MSXML3 MUST be installed successfully prior to installing dotnet35
  # OpenSauce requires this dotnet version
  $WINETRICKS -q dotnet35

  # OpenSauce requires this dotnet version, even when 4.5.1 is installed
  $WINETRICKS -q dotnet40

  # This must be installed, or the Halo installer will display the following error:
  # "Cannot load Pidgen.dll"
  $WINETRICKS mfc42

  # Not sure if this is required
  $WINETRICKS -q d3dx9

  # SPV3 claims to require dotnet 4.5.1
  $WINETRICKS win7
  wine "$DOTNET_451_PATH" /q /norestart

  # Needed for keygen
  # $WINETRICKS vb6run
}

# Install Halo CE, the patch, and opensauce
#
# @todo - perform fileExists checks for necessary files
function installHaloCustomEdition () {
  # Thankfully, this returns properly, so we do not need to have the user
  # indicate that they have finished the installer.
  wine "$HALO_CE_PATH"

  # This patch does not exit properly, therefore we rely on the user to come
  # back here to press enter to continue the script.
  wine "$HALO_CE_PATCH_PATH"
  read -p ""
  echo ""

  # OpenSauce properly exits as well.
  msiexec /i "$OPENSAUCE_PATH"
}

# Install Halo PC from an ISO file, then install the patch
#
# @todo - perform fileExists checks for necessary files
function installHaloPC () {
  mkdir -p "$HALO_ISO_MOUNT_DIR"
  sudo umount "$HALO_ISO_MOUNT_DIR"
  sudo mount -o loop "$HALO_ISO_PATH" "$HALO_ISO_MOUNT_DIR"

  # The Halo installer does not exit properly, therefore we rely on the user to
  # come back here to press enter to continue the script.
  wine "$HALO_ISO_MOUNT_DIR/Setup.Exe"
  read -p ""

  sudo umount "$HALO_ISO_MOUNT_DIR"
  rmdir "$HALO_ISO_MOUNT_DIR"

  # This patch does not exit properly, therefore we rely on the user to come
  # back here to press enter to continue the script.
  wine "$HALO_PC_PATCH_PATH"
  read -p ""
}

function convertMaps () {
  git clone "https://github.com/brainthinks/python_combustion.git"

  cd "python_combustion"

  "./examples/convert_all_retail_maps.sh" "$C_DRIVE_PATH"

  cd ".."
}

function installRynoUI () {
  local pathToMaps="$WINEPREFIX/drive_c/Program Files/Microsoft Games/Halo Custom Edition/maps"

  cp "$RYNO_UI_PATH" "$TMP_DIR"
  cd "$TMP_DIR"
  unzip *.zip

  rm "$pathToMaps/ui.map"
  cp "ui.map" "$pathToMaps"
}


###
### UI / UX
###

function _installDependencies () {
  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  While I have tried my best to ensure that you have to do as      ---"
  echo "---  little work as possible, there are still times where your        ---"
  echo "---  participation will be required.  Here are the parts where you    ---"
  echo "---  will need to interact with the script:                           ---"
  echo "---                                                                   ---"
  echo "---  * you will need to type your sudo password                       ---"
  echo "---  * dotnet35 will require you to type 'Yes'                        ---"
  echo "---  * dotnet35 will require you to type 'Yes' again                  ---"
  echo "---                                                                   ---"
  echo "---  Now that you know what you have to do...                         ---"
  echo "---                                                                   ---"
  echo "---  Press Enter to start the installation!                           ---"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
  read -p ""
  echo ""

  installDependencies

  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  Halo Dependency Installation in Playonlinux Complete!!!          ---"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
}

function _installHaloCustomEdition () {
  echo ""
  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  Halo Custom Edition Installation                                 ---"
  echo "---                                                                   ---"
  echo "---  This will install Halo CE, the Halo CE 1.0.10 Patch, and         ---"
  echo "---  OpenSauce.                                                       ---"
  echo "---                                                                   ---"
  echo "---  YOUR ACTION IS REQUIRED!!!                                       ---"
  echo "---                                                                   ---"
  echo "---  Once the patch finishes installing, you will need to come back   ---"
  echo "---  to this terminal and press ENTER.  If you do not do this, the    ---"
  echo "---  installation process will just be sitting here waiting forever   ---"
  echo "---  and you will think it is frozen.                                 ---"
  echo "---                                                                   ---"
  echo "---  You will not receive another prompt to tell you this!            ---"
  echo "---                                                                   ---"
  echo "---  If you understand your responsibility, press ENTER...            ---"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
  echo ""
  read -p ""

  installHaloCustomEdition

  echo ""
  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  Halo CE Installation in Playonlinux Complete!!!                  ---"
  echo "---                                                                   ---"
  echo "---  Press ENTER to return to the main menu.                          ---"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
  echo ""
  read -p ""
}

function _installHaloPC () {
  echo ""
  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  Halo PC Installation                                             ---"
  echo "---                                                                   ---"
  echo "---  This will install Halo PC, and the Halo PC 1.0.10 Patch.         ---"
  echo "---                                                                   ---"
  echo "---  YOUR ACTION IS REQUIRED!!!                                       ---"
  echo "---                                                                   ---"
  echo "---  Once you are finished installing Halo, you will need to come     ---"
  echo "---  back to this terminal and press ENTER.  If you do not do this,   ---"
  echo "---  the installation process will just be sitting here waiting       ---"
  echo "---  forever and you will think it is frozen.                         ---"
  echo "---                                                                   ---"
  echo "---  You will also have to do this after installing the patch.        ---"
  echo "---                                                                   ---"
  echo "---  You will not receive another prompt to tell you this!            ---"
  echo "---                                                                   ---"
  echo "---  If you understand your responsibility, press ENTER...            ---"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
  echo ""
  read -p ""

  echo "We need sudo to be able to mount the ISO..."
  sudo echo "Acquired Root Permissions..."

  installHaloPC

  echo ""
  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  Halo PC Installation in Playonlinux Complete!!!                  ---"
  echo "---                                                                   ---"
  echo "---  Press ENTER to return to the main menu.                          ---"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
  echo ""
  read -p ""
}

function mainMenu () {
  cleanStart

  echo ""
  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  Halo PC in Playonlinux Installer                                 ---"
  echo "---                                                                   ---"
  echo "---        Wine Version: $(wine --version)"
  echo "---  Virtual Drive Name: $PREFIXNAME"
  echo "---                                                                   ---"
  echo "---  Type in the number that appears in front of the option you want, ---"
  echo "---  then press enter.                                                ---"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
  echo ""

  local options=(\
    "Install Dependencies" \
    "Install Halo CE" \
    "Install SPV3" \
    "Install Halo PC" \
    "Install Halo CE Single Player" \
    "Exit" \
  )

  select option in "${options[@]}"

  do
    case $option in
      "Install Dependencies")
        _installDependencies
        mainMenu
        ;;
      "Install Halo CE")
        _installHaloCustomEdition
        mainMenu
        ;;
      "Install Halo PC")
        _installHaloPC
        mainMenu
        ;;
      "Install Halo CE Single Player")
        convertMaps
        installRynoUI
        mainMenu
        ;;
      "Install SPV3")
        installSPV3
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

# Ensure we have access to the directory in which we started
STARTING_PATH=$(pwd)

# Winetricks may already exist, so find it or download it
detectWinetricks

# Display the main menu
mainMenu $@
