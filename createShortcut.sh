#!/usr/share/playonlinux/playonlinux-bash

# Confirm this script was run in a playonlinux console
if [[ "$PLAYONLINUX" = "" ]]; then
  print_failure "You must run this from a Playonlinux shell!"
  exit 1
fi

# This gives us access to the POL library
# @see - https://www.playonlinux.com/en/documentation.html
source "$PLAYONLINUX/lib/sources"

source "./config.sh"
source "./utils.sh"

function _createHaloCEShortcut () {
  local exe=$1
  local name=$2
  local path_to_maps=$3
  local path_to_profile=$4

  POL_Shortcut "$exe" "$name" "" "$HALO_RUN_ARGS"

  # Before running Halo CE, load the maps that correspond with the game type
  POL_Shortcut_InsertBeforeWine "$name" "rm \"$PATH_TO_CE_MAPS\""
  POL_Shortcut_InsertBeforeWine "$name" "ln -s \"$path_to_maps\" \"$PATH_TO_CE_MAPS\""

  # Before running Halo CE, load the profiles and save games that correspond with the game type
  POL_Shortcut_InsertBeforeWine "$name" "rm \"$PATH_TO_PROFILE_CE\""
  POL_Shortcut_InsertBeforeWine "$name" "ln -s \"$path_to_profile\" \"$PATH_TO_PROFILE_CE\""
}

function createHaloCEShortcut () {
  print_info "Creating Halo CE shortcut"
  _createHaloCEShortcut "$HALO_CE_EXE_FILE" "$HALO_CE_SHORTCUT_NAME" "$PATH_TO_CE_MAPS_BACKUP" "$PATH_TO_PROFILE_CE_BACKUP"
  print_success "Created Halo CE shortcut"
}

function createSPV3Shortcut () {
  print_info "Creating SPV3 shortcut"
  _createHaloCEShortcut "$SPV3_EXE_FILE" "$SPV3_SHORTCUT_NAME" "$PATH_TO_CE_MAPS_SPV3" "$PATH_TO_PROFILE_SPV3"
  print_success "Created SPV3 shortcut"
}

function createSPV3NoLauncherShortcut () {
  print_info "Creating SPV3 without launcher shortcut"
  _createHaloCEShortcut "$HALO_CE_EXE_FILE" "$SPV3_NO_LAUNCHER_SHORTCUT_NAME" "$PATH_TO_CE_MAPS_SPV3" "$PATH_TO_PROFILE_SPV3"
  print_success "Created SPV3 without launcher shortcut"
}

function createMRCShortcut () {
  print_info "Creating Mo's Refined Campaign shortcut"
  _createHaloCEShortcut "$HALO_CE_EXE_FILE" "$MRC_SHORTCUT_NAME" "$PATH_TO_CE_MAPS_MRC" "$PATH_TO_PROFILE_MRC"
  print_success "Created Mo's Refined Campaign shortcut"
}

function createHaloPCShortcut () {
  print_info "Creating Halo PC shortcut"
  POL_Shortcut "$HALO_PC_EXE_FILE" "$HALO_PC_SHORTCUT_NAME" "" "$HALO_RUN_ARGS"
  print_success "Created Halo PC shortcut"
}

function createPCCShortcut () {
  print_info "Creating Halo PC Campaign for Halo CE shortcut"
  _createHaloCEShortcut "$HALO_CE_EXE_FILE" "$PCC_SHORTCUT_NAME" "$PATH_TO_CE_MAPS_PCC" "$PATH_TO_PROFILE_PCC"
  print_success "Created Halo PC Campaign for Halo CE shortcut"
}

function createShortcut () {
  local shortcut=$1

  if [[ "$shortcut" = "$HALO_CE_SHORTCUT_NAME" ]]; then
    createHaloCEShortcut
    return 0
  fi

  if [[ "$shortcut" = "$SPV3_SHORTCUT_NAME" ]]; then
    createSPV3Shortcut
    createSPV3NoLauncherShortcut
    return 0
  fi

  if [[ "$shortcut" = "$MRC_SHORTCUT_NAME" ]]; then
    createMRCShortcut
    return 0
  fi

  if [[ "$shortcut" = "$HALO_PC_SHORTCUT_NAME" ]]; then
    createHaloPCShortcut
    return 0
  fi

  if [[ "$shortcut" = "$PCC_SHORTCUT_NAME" ]]; then
    createPCCShortcut
    return 0
  fi

  if [[ "$shortcut" = "all" ]]; then
    createHaloCEShortcut
    createSPV3Shortcut
    createSPV3NoLauncherShortcut
    createMRCShortcut
    createHaloPCShortcut
    createPCCShortcut
    return 0
  fi

  return 1
}

createShortcut "$1"

error_check_return "Successfully created $1 shortcut(s)" "You must supply a valid shortcut name to create, or 'all' to recreate all of them."
