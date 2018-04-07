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
    print_success "found installed winetricks"
    return 0
  fi

  fileExists "./winetricks"
  if [[ "$?" = "0" ]]; then
    print_success "found local winetricks..."
    WINETRICKS=./winetricks
    return 0
  fi

  print_info "could not find winetricks - downloading latest..."
  wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
  chmod +x winetricks
  WINETRICKS=./winetricks
  print_success "winetricks downloaded..."
  return 0
}

function cleanStart () {
  # Confirm this script was run in a playonlinux terminal
  if [[ "$PLAYONLINUX" = "" ]]; then
    print_failure "You must run this from a Playonlinux shell!"
    # @todo - return 1 here instead of exitting
    exit 1
  fi

  # Delete the tmp directory we use, then re-initialize it
  rm -rf "$TMP_DIR"
  mkdir -p "$TMP_DIR"
  print_info "Deleted temp directory..."

  # Ensure we always start from the same directory
  cd "$PROJECT_DIR"
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
  print_info "Installing msxml3..."
  $WINETRICKS -q msxml3
  error_check "Installed msxml3" "Failed to install msxml3"

  # MSXML3 MUST be installed successfully prior to installing dotnet35
  # OpenSauce requires this dotnet version
  print_info "Installing dotnet35..."
  $WINETRICKS -q dotnet35
  error_check "Installed dotnet35" "Failed to install dotnet35"

  # OpenSauce requires this dotnet version, even when 4.5.1 is installed
  print_info "Installing dotnet40..."
  $WINETRICKS -q dotnet40
  error_check "Installed dotnet40" "Failed to install dotnet40"

  # This must be installed, or the Halo installer will display the following error:
  # "Cannot load Pidgen.dll"
  print_info "Installing mfc42..."
  $WINETRICKS mfc42
  error_check "Installed mfc42" "Failed to install mfc42"

  # Not sure if this is required
  print_info "Installing d3dx9..."
  $WINETRICKS -q d3dx9
  error_check "Installed d3dx9" "Failed to install d3dx9"

  # SPV3 claims to require dotnet 4.5.1
  print_info "Installing dotnet4.5.1..."
  $WINETRICKS win7
  wine "$DOTNET_451_PATH" /q /norestart
  error_check "Installed dotnet4.5.1" "Failed to install dotnet4.5.1"

  # Needed for keygen
  # $WINETRICKS vb6run
}

# Install Halo CE, the patch, and opensauce
#
# @todo - perform fileExists checks for necessary files
function installHaloCustomEdition () {
  # Thankfully, this returns properly, so we do not need to have the user
  # indicate that they have finished the installer.
  print_info "Installing Halo CE"
  wine "$HALO_CE_PATH"
  error_check "Installed Halo CE" "Failed to install Halo CE"

  # This patch does not exit properly, therefore we rely on the user to come
  # back here to press enter to continue the script.
  print_info "Installing Halo CE Patch 1.10"
  wine "$HALO_CE_PATCH_PATH"
  print_info "Don't forget to hit enter when you're finished!"
  read -p ""
  error_check "Installed Halo CE Patch 1.10" "Failed to install Halo CE Patch 1.10"

  # OpenSauce properly exits as well.
  print_info "Installing OpenSauce"
  msiexec /i "$OPENSAUCE_PATH"
  error_check "Installed OpenSauce" "Failed to install OpenSauce"

  # Back up the original map set
  print_info "Backing up the Halo CE maps"
  mv "$PATH_TO_CE_MAPS" "$PATH_TO_CE_MAPS_BACKUP"
  error_check "Backed up the Halo CE maps" "Failed to back up the Halo CE maps"
}

function installSPV3 () {
  print_info "Creating SPV3 maps folder"
  cp -R "$PATH_TO_CE_MAPS_BACKUP" "$PATH_TO_CE_MAPS_SPV3"
  error_check "Created SPV3 maps folder" "Failed to create SPV3 maps folder"

  # Allows the profile manager to identify which map set this is
  print_info "Creating SPV3 ID file"
  touch "$PATH_TO_SPV3_ID"
  error_check "Created SPV3 ID file" "Failed to create SPV3 ID file"

  mkdir -p "$PATH_TO_CE_MAPS_SPV3/data_files"
  mkdir -p "$TMP_DIR/SPV3"

  print_info "Extracting SPV3 archive"
  file-roller "$SPV3_PATH" -e "$TMP_DIR/SPV3"
  error_check "Extracted SPV3 archive" "Failed to extract SPV3 archive"

  cd "$TMP_DIR/SPV3"

  print_info "Extracting SPV3 executable"
  file-roller "$TMP_DIR/SPV3/SPV3.1.0f.exe" -e "$TMP_DIR/SPV3"
  error_check "Extracted SPV3 executable" "Failed extract SPV3 executable"

  print_info "Extracting SPV3 content archives"
  file-roller *.yumi -e "$TMP_DIR/SPV3"
  error_check "Extracted SPV3 content archives" "Failed to extract SPV3 content archives"

  print_info "Moving SPV3 data files"
  mv "./-bitmaps.map" "$PATH_TO_CE_MAPS_SPV3/data_files"
  mv "./-loc.map" "$PATH_TO_CE_MAPS_SPV3/data_files"
  mv "./-sounds.map" "$PATH_TO_CE_MAPS_SPV3/data_files"
  error_check "Moved SPV3 data files" "Failed to move SPV3 data files"

  print_info "Moving SPV3 yelo maps"
  mv *.yelo "$PATH_TO_CE_MAPS_SPV3"
  error_check "Moved SPV3 yelo maps" "Failed to move SPV3 yelo maps"

  print_info "Moving SPV3 maps"
  mv *.map "$PATH_TO_CE_MAPS_SPV3"
  error_check "Moved SPV3 maps" "Failed to move SPV3 maps"

  # Even though these are only needed for SPV3, it doesn't hurt anything to keep
  # them permanently in the Halo CE directory.
  print_info "Moving SPV3 launcher"
  mv "ICON.ICO" "$PATH_TO_CE_MAPS_SPV3/.."
  mv "SPV3.EXE" "$PATH_TO_CE_MAPS_SPV3/.."
  error_check "Moved SPV3 launcher" "Failed to move SPV3 launcher"

  cd "$PROJECT_DIR"

  rm -rf "$TMP_DIR/SPV3"
}

function installRynoUI () {
  cp "$RYNO_UI_PATH" "$TMP_DIR"
  cd "$TMP_DIR"
  unzip *.zip

  rm "$1/ui.map"
  mv "ui.map" "$1"
}

function installMosRefinedCampaign () {
  cp -R "$PATH_TO_CE_MAPS_BACKUP" "$PATH_TO_CE_MAPS_MRC"

  installRynoUI "$PATH_TO_CE_MAPS_MRC"

  cd "$TMP_DIR"
  file-roller -h "$MRC_PATH"

  cd "$TMP_DIR/halo ce fixed sp campaign"

  file-roller -h ./*.zip

  # @see - https://stackoverflow.com/a/9449633
  IFS=$'\n'
  declare -a maps=($(find ./ -name "*.map"))
  unset IFS

  # @see - https://stackoverflow.com/a/8880633
  for map in "${maps[@]}"
  do
    mv "$map" "$PATH_TO_CE_MAPS_MRC"
  done

  # Allows the profile manager to identify which map set this is
  touch "$PATH_TO_MRC_ID"

  cd "$PROJECT_DIR"
  rm -rf "$TMP_DIR/halo ce fixed sp campaign"
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

function installHaloCEHaloPCCampaign () {
  cp -R "$PATH_TO_CE_MAPS_BACKUP" "$PATH_TO_CE_MAPS_PCC"

  # Allows the profile manager to identify which map set this is
  touch "$PATH_TO_PCC_ID"

  installRynoUI "$PATH_TO_CE_MAPS_PCC"

  git clone "https://github.com/brainthinks/python_combustion.git"

  cd "python_combustion"

  # @todo - need to specify the target path!
  "./examples/convert_all_retail_maps.sh" "$PATH_TO_C_DRIVE"

  cd "$PROJECT_DIR"
}


###
### UI / UX
###

function _installDependencies () {
  echo -e "${ORANGE}"
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
  echo -e "${NC}"
  read -p ""
  echo ""

  installDependencies

  echo -e "${ORANGE}"
  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  Halo Dependency Installation in Playonlinux Complete!!!          ---"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
  echo -e "${NC}"
}

function _installHaloCustomEdition () {
  echo -e "${ORANGE}"
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
  echo -e "${NC}"
  read -p ""

  installHaloCustomEdition

  echo -e "${ORANGE}"
  echo ""
  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  Halo CE Installation in Playonlinux Complete!!!                  ---"
  echo "---                                                                   ---"
  echo "---  Press ENTER to return to the main menu.                          ---"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
  echo ""
  echo -e "${NC}"
  read -p ""
}

function _installHaloPC () {
  echo -e "${ORANGE}"
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
  echo -e "${NC}"
  read -p ""

  echo "We need sudo to be able to mount the ISO..."
  sudo echo "Acquired Root Permissions..."

  installHaloPC

  echo -e "${ORANGE}"
  echo ""
  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  Halo PC Installation in Playonlinux Complete!!!                  ---"
  echo "---                                                                   ---"
  echo "---  Press ENTER to return to the main menu.                          ---"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
  echo ""
  echo -e "${NC}"
  read -p ""
}

function mainMenu () {
  cleanStart

  echo -e "${ORANGE}"
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
  echo -e "${NC}"

  local options=(\
    "Step 1 - Install Dependencies" \
    "Step 2 - Install Halo CE" \
    "Step 3 - Install SPV3" \
    "Step 4 - Install Halo CE Mo's Refined Campaign" \
    "Step 5 - Install Halo PC" \
    "Step 6 - Install Halo CE Campaign from Halo PC" \
    "Step 7 - Open Halo CE Campaign Manager" \
    "Exit" \
  )

  select option in "${options[@]}"

  do
    case $option in
      "Step 1 - Install Dependencies")
        _installDependencies
        mainMenu
        ;;
      "Step 2 - Install Halo CE")
        _installHaloCustomEdition
        mainMenu
        ;;
      "Step 3 - Install SPV3")
        installSPV3
        mainMenu
        ;;
      "Step 4 - Install Halo CE Mo's Refined Campaign")
        installMosRefinedCampaign
        mainMenu
        ;;
      "Step 5 - Install Halo PC")
        _installHaloPC
        mainMenu
        ;;
      "Step 6 - Install Halo CE Campaign from Halo PC")
        installHaloCEHaloPCCampaign
        mainMenu
        ;;
      "Step 7 - Open Halo CE Campaign Manager")
        ./manager.sh
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

source "./utils.sh"
source "./config.sh"

# Winetricks may already exist, so find it or download it
detectWinetricks

# Display the main menu
mainMenu $@
