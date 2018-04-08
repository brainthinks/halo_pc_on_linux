#!/usr/bin/env bash

# @todos:
# untar the iso rather than mounting it
# create log files to track individual installers if they requireUserToContinue
# download as many of the files as possible
# create shortcuts

###
### Helpers
###

function cleanStart () {
  # Confirm this script was run in a playonlinux terminal
  if [[ "$PLAYONLINUX" = "" ]]; then
    print_failure "You must run this from a Playonlinux shell!"
    # @todo - return 1 here instead of exitting
    exit 1
  fi

  # Ensure we always start from the same directory
  cd "$PROJECT_DIR"

  # Delete the tmp directory we use, then re-initialize it
  rm -rf "$TMP_DIR"
  mkdir -p "$TMP_DIR"
  error_check "Deleted temp directory" "Failed to delete temp directory"

  # Reset downloaded dependencies
  rm -rf "dependencies"
  mkdir -p "dependencies"
}

function confirmWineVersion () {
  if [[ "$WINEVERSION" = "$DOTNET_WINE_VERSION" ]]; then
    print_failure "$WINEVERSION is only to be used to install .net dependencies.  Switch to a 3.x version."
    exit 1
  fi
}

function getWinetricks () {
  print_info "Downloading latest version of winetricks..."
  cd "dependencies"
  wget "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks"
  error_check "Downloaded winetricks" "Failed to download winetricks"

  chmod +x winetricks
  cd "$PROJECT_DIR"
}


###
### Installers
###

# Install all necessary dependencies to be able to run the Windows Halo
# installers.
#
# @todo - can we detect whether or not these have already been installed?
function installDependenciesDotNet () {
  if [[ "$WINEVERSION" != "$DOTNET_WINE_VERSION" ]]; then
    print_failure "$DOTNET_WINE_VERSION must be used to install .net dependencies.  You appear to be running $WINEVERSION.  Switch to $DOTNET_WINE_VERSION."
    exit 1
  fi

  getWinetricks
  WINETRICKS="$PROJECT_DIR/dependencies/winetricks"

  # A prerequisite for dotnet35
  print_info "Installing msxml3..."
  $WINETRICKS -q msxml3
  error_check "Installed msxml3" "Failed to install msxml3"

  # MSXML3 MUST be installed successfully prior to installing dotnet35
  # OpenSauce requires this dotnet version
  print_info "Installing dotnet35sp1..."
  $WINETRICKS -q dotnet35sp1
  # This finishes with an error code...
  print_success "Installed dotnet35sp1"

  # OpenSauce requires this dotnet version, even when 4.5.1 is installed
  print_info "Installing dotnet40..."
  $WINETRICKS -q dotnet40
  error_check "Installed dotnet40" "Failed to install dotnet40"

  # SPV3 claims to require dotnet 4.5.1
  # Note that we cannot install this with winetricks because it will fail, since
  # winetricks will complain that this is incompatible with the already-installed
  # dotnet35sp1, and will not allow you to install it
  print_info "Installing dotnet4.5.1..."
  $WINETRICKS win7
  wine "$DOTNET_451_PATH" /q /norestart
  print_success "Installed dotnet4.5.1"

  # Needed for keygen
  print_info "Installing vb6run..."
  $WINETRICKS vb6run
  error_check "Installed vb6run" "Failed to install vb6run"

  echo -e "${BLUE}"
  echo ""
  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  Now that the .net dependencies have been installed, you need to  ---"
  echo "---  go back into play on linux and set this virtual drive's wine     ---"
  echo "---  version to $DOTNET_WINE_VERSION"
  echo "---                                                                   ---"
  echo "---                                                                   ---"
  echo "---  press enter to exit...                                           ---"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
  echo ""
  echo -e "${NC}"
  read -p ""
}

function installDependencies () {
  confirmWineVersion

  getWinetricks
  WINETRICKS="$PROJECT_DIR/dependencies/winetricks"

  # This must be installed, or the Halo installer will display the following error:
  # "Cannot load Pidgen.dll"
  print_info "Installing mfc42..."
  $WINETRICKS -q mfc42
  error_check "Installed mfc42" "Failed to install mfc42"

  # It appears as though SPV3 wants d3dx9_43, but I'm not sure.
  print_info "Installing d3dx9..."
  $WINETRICKS -q d3dx9_43
  error_check "Installed d3dx9" "Failed to install d3dx9"

  print_info "Configuring Virtual Drive..."
  regedit halo_drive_configuration.reg
  error_check "Configured virtual drive" "Failed to configure virtual drive"

  print_info "Setting Windows version to 7..."
  $WINETRICKS win7
  print_success "Set Windows version to 7"
}

# Install Halo CE, the patch, and opensauce
#
# @todo - perform fileExists checks for necessary files
function installHaloCustomEdition () {
  confirmWineVersion

  # Thankfully, this returns properly, so we do not need to have the user
  # indicate that they have finished the installer.
  print_info "Installing Halo CE"
  wine "$HALO_CE_PATH"
  # We can't do a prpper error check here because Halo CE exits with an error code...
  print_success "Installed Halo CE"

  print_info "Installing Halo CE Patch 1.10"
  wine "$HALO_CE_PATCH_PATH"
  wineserver -w
  print_info "Installed Halo CE Patch 1.10"

  # OpenSauce properly exits as well.
  print_info "Installing OpenSauce"
  msiexec /i "$OPENSAUCE_PATH"
  error_check "Installed OpenSauce" "Failed to install OpenSauce"

  # Back up the original map set
  print_info "Backing up the Halo CE maps"
  mv "$PATH_TO_CE_MAPS" "$PATH_TO_CE_MAPS_BACKUP"
  error_check "Backed up the Halo CE maps" "Failed to back up the Halo CE maps"

  # Back up the original profiles
  print_info "Backing up the Halo CE profiles"
  mv "$PATH_TO_PROFILE_CE" "$PATH_TO_PROFILE_CE_BACKUP"
  error_check "Backed up the Halo CE profiles" "Failed to back up the Halo CE profiles"
}

function installSPV3 () {
  confirmWineVersion

  print_info "Creating SPV3 maps folder"
  cp -R "$PATH_TO_CE_MAPS_BACKUP" "$PATH_TO_CE_MAPS_SPV3"
  error_check "Created SPV3 maps folder" "Failed to create SPV3 maps folder"

  # Allows the profile manager to identify which map set this is
  print_info "Creating SPV3 ID file"
  touch "$PATH_TO_CE_MAPS_SPV3/$PATH_TO_SPV3_ID"
  error_check "Created SPV3 ID file" "Failed to create SPV3 ID file"

  print_info "Creating SPV3 profiles"
  cp -R "$PATH_TO_PROFILE_CE_BACKUP" "$PATH_TO_PROFILE_SPV3"
  error_check "Created SPV3 profiles" "Failed to create SPV3 profiles"

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
  print_info "Moving SPV3 core assets"
  mv "CONTROLS/CHIMERA.DLL" "$PATH_TO_CE_MAPS_SPV3/../controls"
  mv "CAMERA.TXT" "$PATH_TO_CE_MAPS_SPV3/.."
  mv "CHEAPE.MAP" "$PATH_TO_CE_MAPS_SPV3/.."
  mv "CHEAPEDLLG.DLL" "$PATH_TO_CE_MAPS_SPV3/.."
  mv "CHEAPEDLLS.DLL" "$PATH_TO_CE_MAPS_SPV3/.."
  mv "CHEAPEDLLT.DLL" "$PATH_TO_CE_MAPS_SPV3/.."
  mv "CHEAPEDLLT_OLD.DLL" "$PATH_TO_CE_MAPS_SPV3/.."
  mv "D3DX9_43.DLL" "$PATH_TO_CE_MAPS_SPV3/.."
  mv "DSOUND.DLL" "$PATH_TO_CE_MAPS_SPV3/.."
  mv "DSOUND.INI" "$PATH_TO_CE_MAPS_SPV3/.."
  mv "DSOUNDLOG.TXT" "$PATH_TO_CE_MAPS_SPV3/.."
  mv "PCML_0.M" "$PATH_TO_CE_MAPS_SPV3/.."
  mv "PCMR_0.M" "$PATH_TO_CE_MAPS_SPV3/.."
  mv "ICON.ICO" "$PATH_TO_CE_MAPS_SPV3/.."
  mv "SPV3.EXE" "$PATH_TO_CE_MAPS_SPV3/.."
  error_check "Moved SPV3 core assets" "Failed to move SPV3 core assets"

  cd "$PROJECT_DIR"

  rm -rf "$TMP_DIR/SPV3"
}

function installRynoUI () {
  confirmWineVersion

  local destination="$1"

  print_info "Extracting Ryno UI"
  cp "$RYNO_UI_PATH" "$TMP_DIR"
  cd "$TMP_DIR"
  unzip "$RYNO_UI_FILE"
  error_check "Extracted Ryno UI" "Failed to extract Ryno UI"

  print_info "Replacing stock UI with Ryno UI"
  rm "$destination/ui.map"
  mv "ui.map" "$destination"
  error_check "Replaced stock UI with Ryno UI" "Failed to replace stock UI with Ryno UI"

  cd "$PROJECT_DIR"
}

function installMosRefinedCampaign () {
  confirmWineVersion

  print_info "Creating Mo's Refined Campaign maps folder"
  cp -R "$PATH_TO_CE_MAPS_BACKUP" "$PATH_TO_CE_MAPS_MRC"
  error_check "Created Mo's Refined Campaign maps folder" "Failed to create Mo's Refined Campaign maps folder"

  print_info "Installing Ryno UI"
  installRynoUI "$PATH_TO_CE_MAPS_MRC"
  error_check "Installed Ryno UI" "Failed to install Ryno UI"

  print_info "Extracting MRC zip"
  cp "$MRC_PATH" "$TMP_DIR"
  cd "$TMP_DIR"
  file-roller -h "$MRC_FILE"
  error_check "Extracted MRC zip" "Failed to extract MRC zip"

  print_info "Extracting MRC content zips"
  cd "$TMP_DIR/halo ce fixed sp campaign"
  file-roller -h ./*.zip
  error_check "Extracted MRC content zips" "Failed to extract MRC content zips"

  # @see - https://stackoverflow.com/a/9449633
  IFS=$'\n'
  print_info "Collecting MRC map files"
  declare -a maps=($(find ./ -name "*.map"))
  error_check "Collected MRC map files" "Failed to collect MRC map files"
  unset IFS

  # @see - https://stackoverflow.com/a/8880633
  for map in "${maps[@]}"
  do
    print_info "Moving $map map file"
    mv "$map" "$PATH_TO_CE_MAPS_MRC"
    error_check "Moved $map map file" "Failed to move $map map file"
  done

  # Allows the profile manager to identify which map set this is
  print_info "Creating MRC ID file"
  touch "$PATH_TO_CE_MAPS_MRC/$PATH_TO_MRC_ID"
  error_check "Created MRC ID file" "Failed to create MRC ID file"

  print_info "Creating MRC profiles"
  cp -R "$PATH_TO_PROFILE_CE_BACKUP" "$PATH_TO_PROFILE_MRC"
  error_check "Created MRC profiles" "Failed to create MRC profiles"

  cd "$PROJECT_DIR"
  rm -rf "$TMP_DIR/halo ce fixed sp campaign"
}

# Install Halo PC from an ISO file, then install the patch
#
# @todo - perform fileExists checks for necessary files
function installHaloPC () {
  confirmWineVersion

  echo "We need sudo to be able to mount the ISO..."
  sudo echo "Acquired Root Permissions..."

  print_info "Mounting Halo PC ISO"
  mkdir -p "$HALO_ISO_MOUNT_DIR"
  sudo umount "$HALO_ISO_MOUNT_DIR"
  sudo mount -o loop "$HALO_ISO_PATH" "$HALO_ISO_MOUNT_DIR"
  error_check "Mounted Halo PC ISO" "Failed to mount Halo PC ISO"

  # The Halo installer does not exit properly, therefore we rely on the user to
  # come back here to press enter to continue the script.
  print_info "Installing Halo PC"
  wine "$HALO_ISO_MOUNT_DIR/Setup.Exe"
  wineserver -w
  print_info "Installed Halo PC"

  print_info "Unmounting Halo PC ISO"
  sudo umount "$HALO_ISO_MOUNT_DIR"
  error_check "Unmounted Halo PC ISO" "Failed to unmount Halo PC ISO"

  rmdir "$HALO_ISO_MOUNT_DIR"

  # This patch does not exit properly, therefore we rely on the user to come
  # back here to press enter to continue the script.
  print_info "Installing Halo PC Patch 1.10"
  wine "$HALO_PC_PATCH_PATH"
  wineserver -w
  print_info "Installed Halo PC Patch 1.10"
}

function installHaloCEHaloPCCampaign () {
  confirmWineVersion

  print_info "Creating Halo PC Campaign for Halo CE maps folder"
  # We need to start out with the maps in the "maps" folder so python_combustion
  # will convert them properly...
  cp -R "$PATH_TO_CE_MAPS_BACKUP" "$PATH_TO_CE_MAPS"
  error_check "Created Halo PC Campaign for Halo CE maps folder" "Failed to create Halo PC Campaign for Halo CE maps folder"

  print_info "Cloning Python Combustion, which will convert the Halo PC maps to work in Halo CE"
  cd "dependencies"
  git clone "https://github.com/brainthinks/python_combustion.git"
  error_check "Cloned Python Combustion" "Failed to clone Python Combustion"

  cd "python_combustion"

  # @todo - need to specify the target path!
  print_info "Converting the Halo PC maps to work in Halo CE"
  "./examples/convert_all_retail_maps.sh" "$PATH_TO_C_DRIVE"
  error_check "Converted Halo PC maps" "Failed to convert Halo PC maps"

  cd "$PROJECT_DIR"

  print_info "Moving maps into PCC folder"
  # We need to start out with the maps in the "maps" folder so python_combustion
  # will convert them properly...
  mv "$PATH_TO_CE_MAPS" "$PATH_TO_CE_MAPS_PCC"
  error_check "Moved maps into PCC folder" "Failed to move maps into PCC folder"

  # Allows the profile manager to identify which map set this is
  print_info "Creating PCC ID file"
  touch "$PATH_TO_CE_MAPS_PCC/$PATH_TO_PCC_ID"
  error_check "Created PCC ID file" "Failed to create PCC ID file"

  print_info "Creating PCC profiles"
  cp -R "$PATH_TO_PROFILE_CE_BACKUP" "$PATH_TO_PROFILE_PCC"
  error_check "Created PCC profiles" "Failed to create PCC profiles"

  print_info "Installing Ryno UI"
  installRynoUI "$PATH_TO_CE_MAPS_PCC"
  error_check "Installed Ryno UI" "Failed to install Ryno UI"
}

function mainMenu () {
  cleanStart

  echo -e "${ORANGE}"
  echo ""
  echo "-------------------------------------------------------------------------"
  echo "---                                                                   ---"
  echo "---  Halo PC in Playonlinux Installer                                 ---"
  echo "---                                                                   ---"
  echo "---        Wine Version: $WINEVERSION"
  echo "---  Virtual Drive Name: $PREFIXNAME"
  echo "---                                                                   ---"
  echo "---  Type in the number that appears in front of the option you want, ---"
  echo "---  then press enter.                                                ---"
  echo "---                                                                   ---"
  echo "-------------------------------------------------------------------------"
  echo ""
  echo -e "${NC}"

  local options=(\
    "Step 1 - Install .net Dependencies using $DOTNET_WINE_VERSION" \
    "Step 2 - Install Dependencies" \
    "Step 3 - Install Halo CE" \
    "Step 4 - Install SPV3" \
    "Step 5 - Install Halo CE Mo's Refined Campaign" \
    "Step 6 - Install Halo PC" \
    "Step 7 - Install Halo CE Campaign from Halo PC" \
    "Step 8 - Open Halo CE Campaign Manager" \
    "Exit" \
  )

  select option in "${options[@]}"

  do
    case $option in
      "Step 1 - Install .net Dependencies using $DOTNET_WINE_VERSION")
        installDependenciesDotNet
        mainMenu
        ;;
      "Step 2 - Install Dependencies")
        installDependencies
        mainMenu
        ;;
      "Step 3 - Install Halo CE")
        installHaloCustomEdition
        mainMenu
        ;;
      "Step 4 - Install SPV3")
        installSPV3
        mainMenu
        ;;
      "Step 5 - Install Halo CE Mo's Refined Campaign")
        installMosRefinedCampaign
        mainMenu
        ;;
      "Step 6 - Install Halo PC")
        installHaloPC
        mainMenu
        ;;
      "Step 7 - Install Halo CE Campaign from Halo PC")
        installHaloCEHaloPCCampaign
        mainMenu
        ;;
      "Step 8 - Open Halo CE Campaign Manager")
        ./manager.sh
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

source "./utils.sh"
source "./config.sh"

WINEVERSION=$(wine --version)

# Display the main menu
mainMenu $@
