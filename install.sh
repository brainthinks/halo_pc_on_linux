#!/usr/bin/env bash

DOTNET_451_PATH="./NDP451-KB2858728-x86-x64-AllOS-ENU.exe"
HALO_ISO_PATH="./HALO.ISO"
HALO_MOUNT_DIR="/tmp/halo_installer"
HALO_PC_PATCH_PATH="./halopc-patch-1.0.10.exe"
HALO_CE_PATH="./halocesetup_en_1.00.exe"
HALO_CE_PATCH_PATH="./haloce-patch-1.0.10.exe"
OPENSAUCE_PATH="./OpenSauce_Halo1_CE_20150302.msi"

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

function verifyInPOLShell () {
  if [[ "$PLAYONLINUX" = "" ]]; then
    echo "You must run this from a Playonlinux shell!"
    exit 1
  fi
}

function getSudo () {
  sudo echo "Acquired Root Permissions..."
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

function installPrerequisites () {
  # Install the latest winetricks
  wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
  chmod +x winetricks

  # A prerequisite for dotnet35
  ./winetricks -q msxml3

  # MSXML3 MUST be installed successfully prior to installing dotnet35
  # OpenSauce requires this dotnet version
  ./winetricks -q dotnet35

  # OpenSauce requires this dotnet version, even when 4.5.1 is installed
  ./winetricks -q dotnet40

  # This must be installed, or the Halo installer will display the following error:
  # "Cannot load Pidgen.dll"
  ./winetricks mfc42

  # Not sure if this is required
  ./winetricks -q d3dx9

  # SPV3 claims to require dotnet 4.5.1
  ./winetricks win7
  wine "$DOTNET_451_PATH" /q /norestart
}

function installHaloPC () {
  mkdir -p "$HALO_MOUNT_DIR"
  sudo umount "$HALO_MOUNT_DIR"
  sudo mount -o loop "$HALO_ISO_PATH" "$HALO_MOUNT_DIR"

  wine "$HALO_MOUNT_DIR/Setup.Exe"
  requireUserToContinue "Halo PC"

  sudo umount "$HALO_MOUNT_DIR"
  rmdir "$HALO_MOUNT_DIR"

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
# installPrerequisites
installHaloPC
installHaloCustomEdition
installOpenSauce

echo "-------------------------------------------------------------------------"
echo "---                                                                   ---"
echo "---  Halo PC in Playonlinux Installation Complete!!!                  ---"
echo "---                                                                   ---"
echo "-------------------------------------------------------------------------"

# @todos:
# untar the iso rather than mounting it
# create log files to track individual installers if they requireUserToContinue
# download as many of the files as possible
# configure wine? desktop, cmst, etc
# create shortcuts
# why isn't POL_Wine available?
# is there any way to get rid of requireUserToContinue?
