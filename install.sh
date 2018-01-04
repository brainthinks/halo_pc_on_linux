#!/usr/bin/env bash

BASE_DIR="./assets"

DOTNET_451_PATH="$BASE_DIR/NDP451-KB2858728-x86-x64-AllOS-ENU.exe"
HALO_ISO_MOUNT_DIR="/tmp/halo_pc_on_linux/HALO"
HALO_ISO_PATH="$BASE_DIR/HALO.ISO"
HALO_PC_PATCH_PATH="$BASE_DIR/halopc-patch-1.0.10.exe"
HALO_CE_PATH="$BASE_DIR/halocesetup_en_1.00.exe"
HALO_CE_PATCH_PATH="$BASE_DIR/haloce-patch-1.0.10.exe"
OPENSAUCE_PATH="$BASE_DIR/OpenSauce_Halo1_CE_20150302.msi"
SERIAL=""

function verifyInPOLShell () {
  if [[ "$PLAYONLINUX" = "" ]]; then
    echo "You must run this from a Playonlinux shell!"
    exit 1
  fi
}

function getSudo () {
  sudo echo "Acquired Root Permissions..."
}

function dependencyExists () {
  if [[ $(which $1 | wc -l) = 1 ]]; then
    return 0
  else
    return 1
  fi
}

function fileExists () {
  if [[ -f "$1" ]]; then
    return 0
  else
    return 1
  fi
}

function errorCheck () {
  echo '@todo'
}

# @todo - is there an option to wait?
function requireUserToContinue () {
  local title=$1

  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  $title"
  echo "---                                                                   ---"
  echo "---  Once $title has finished installing,"
  echo "---  press Enter to continue..."
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"

  read -p ""
  echo ""
}

function installWinetricks () {
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

function installPrerequisites () {
  installWinetricks

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
}

function installGraphicalAutomatorDependencies () {
  # All of these are needed to run the sikulix package
  sudo apt install -y \
    openjdk-8-jre \
    libopencv-dev \
    tesseract-ocr \
    xdotool \
    wmctrl
}

function installHaloPC () {
  mkdir -p "$HALO_ISO_MOUNT_DIR"
  sudo umount "$HALO_ISO_MOUNT_DIR"
  sudo mount -o loop "$HALO_ISO_PATH" "$HALO_ISO_MOUNT_DIR"

  wine "$HALO_ISO_MOUNT_DIR/Setup.Exe"
  requireUserToContinue "Halo PC"

  sudo umount "$HALO_ISO_MOUNT_DIR"
  rmdir "$HALO_ISO_MOUNT_DIR"

  wine "$HALO_PC_PATCH_PATH"
  requireUserToContinue "Halo PC 1.0.10 patch"
}

function installHaloCustomEdition () {
  wine "$HALO_CE_PATH"

  wine "$HALO_CE_PATCH_PATH"
  requireUserToContinue "Halo CE 1.0.10 patch"
}

function installOpenSauce () {
  msiexec /i OpenSauce_Halo1_CE_20150302.msi
}

function main () {
  echo ""
  echo ""
  echo ""
  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  Halo PC in Playonlinux Installer                                 ---"
  echo "---                                                                   ---"
  echo "---  Unfortunately, this is an interactive script!  You will need to  ---"
  echo "---  be present for the entire installation!  Sorry!                  ---"
  echo "---                                                                   ---"
  echo "---        Wine Version: $(wine --version)"
  echo "---  Virtual Drive Name: $PREFIXNAME"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
  echo ""
  echo ""
  echo ""

  verifyInPOLShell

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
  echo "---  * you will have to press enter in the terminal after:            ---"
  echo "---    * Halo PC finishes installing                                  ---"
  echo "---    * Halo PC patch 1.0.10 finishes installing                     ---"
  echo "---    * Halo CE patch 1.0.10 finishes installing                     ---"
  echo "---                                                                   ---"
  echo "---  Now that you know what you have to do...                         ---"
  echo "---                                                                   ---"
  echo "---  Press Enter to start the installation!                           ---"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
  read -p ""
  echo ""

  getSudo
  installPrerequisites
  installHaloPC
  installHaloCustomEdition
  installOpenSauce

  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  Halo PC in Playonlinux Installation Complete!!!                  ---"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
}

# @todos:
# implement sikuli jar - figure out how to pass parameters to it
# don't require the user to type "Yes" to override registry settings
# untar the iso rather than mounting it
# create log files to track individual installers if they requireUserToContinue
# download as many of the files as possible
# configure wine? desktop, cmst, etc
# create shortcuts
# why isn't POL_Wine available?
# is there any way to get rid of requireUserToContinue?

main $@
