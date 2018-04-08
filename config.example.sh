#!/usr/bin/env bash

# This isn't used, but you can track your serial number here if you'd like
SERIAL=""


###
### Asset File Names
###
### The names of all of the files you downloaded.  If you didn't change the
### names of the files after you downloaded them, you won't need to change any
### of their names here, except for `mrc.zip`
###

# Dependencies
DOTNET_451_FILE="NDP451-KB2858728-x86-x64-AllOS-ENU.exe"

# Halo PC
HALO_ISO_FILE="HALO.ISO"
HALO_PC_PATCH_FILE="halopc-patch-1.0.10.exe"

# Halo CE
HALO_CE_FILE="halocesetup_en_1.00.exe"
HALO_CE_PATCH_FILE="haloce-patch-1.0.10.exe"
OPENSAUCE_FILE="OpenSauce_Halo1_CE_20150302.msi"

# SPV3
SPV3_FILE="SPV3.1.0f.zip"

# Mo's Refined Campaign
MRC_FILE="mrc.zip"

# Ryno UI Launcher
RYNO_UI_FILE="RynO_UI.zip"


###
### Shortcut Names
###
### The names of the shortcuts that will appear in playonlinux
###

HALO_CE_SHORTCUT_NAME="Halo CE"
SPV3_SHORTCUT_NAME="SPV3"
SPV3_NO_LAUNCHER_SHORTCUT_NAME="$SPV3_SHORTCUT_NAME (no launcher)"
MRC_SHORTCUT_NAME="Halo CE Mo's Refined Campaign"
HALO_PC_SHORTCUT_NAME="Halo PC"
PCC_SHORTCUT_NAME="Halo CE PC Campaign"


# ---------------------------------------------------------------------------- #
#              You probably don't need to change anything below.               #
# ---------------------------------------------------------------------------- #

###
### Project Directories
###

# So we can get back to home
PROJECT_DIR=$(pwd)

# The place where you put all the downloaded files.  If you followed
# the guide from the README, you won't need to change this.
ASSETS_DIR="$PROJECT_DIR/assets"

# The place where extracted files will be temporarily stored
TMP_DIR="/tmp/halo_pc_on_linux"


###
### Halo Installations
###

# Base paths
PATH_TO_C_DRIVE="$WINEPREFIX/drive_c"
PATH_TO_PC_INSTALLATION="$PATH_TO_C_DRIVE/Program Files/Microsoft Games/Halo"
PATH_TO_CE_INSTALLATION="$PATH_TO_C_DRIVE/Program Files/Microsoft Games/Halo Custom Edition"

# Halo executables
HALO_PC_EXE_FILE="halo.exe"
HALO_CE_EXE_FILE="haloce.exe"
SPV3_EXE_FILE="SPV3.EXE"
HALO_PC_EXE_PATH="$PATH_TO_PC_INSTALLATION/$HALO_PC_EXE_FILE"
HALO_CE_EXE_PATH="$PATH_TO_CE_INSTALLATION/$HALO_CE_EXE_FILE"
SPV3_EXE_PATH="$PATH_TO_CE_INSTALLATION/$SPV3_EXE_FILE"
HALO_RUN_ARGS="-vidmode 1920,1080,60 -console"

# Paths to the Halo CE Maps
PATH_TO_CE_MAPS="$PATH_TO_CE_INSTALLATION/maps"
PATH_TO_CE_MAPS_BACKUP="$PATH_TO_CE_MAPS.original"
PATH_TO_CE_MAPS_SPV3="$PATH_TO_CE_MAPS.spv3"
PATH_TO_CE_MAPS_MRC="$PATH_TO_CE_MAPS.mrc"
PATH_TO_CE_MAPS_PCC="$PATH_TO_CE_MAPS.pcc"

# Paths to the Halo CE Profiles
PATH_TO_PROFILE_CE="$PATH_TO_C_DRIVE/users/$USER/My Documents/My Games/Halo CE"
PATH_TO_PROFILE_CE_BACKUP="$PATH_TO_PROFILE_CE.original"
PATH_TO_PROFILE_SPV3="$PATH_TO_PROFILE_CE.spv3"
PATH_TO_PROFILE_MRC="$PATH_TO_PROFILE_CE.mrc"
PATH_TO_PROFILE_PCC="$PATH_TO_PROFILE_CE.pcc"


###
### Asset File Paths
###

# Dependencies
DOTNET_451_PATH="$ASSETS_DIR/$DOTNET_451_FILE"

# Halo PC
HALO_ISO_MOUNT_DIR="$TMP_DIR/HALO"
HALO_ISO_PATH="$ASSETS_DIR/$HALO_ISO_FILE"
HALO_PC_PATCH_PATH="$ASSETS_DIR/$HALO_PC_PATCH_FILE"

# Halo CE
HALO_CE_PATH="$ASSETS_DIR/$HALO_CE_FILE"
HALO_CE_PATCH_PATH="$ASSETS_DIR/$HALO_CE_PATCH_FILE"
OPENSAUCE_PATH="$ASSETS_DIR/$OPENSAUCE_FILE"

# SPV3
SPV3_PATH="$ASSETS_DIR/$SPV3_FILE"

# Mo's Refined Campaign
MRC_PATH="$ASSETS_DIR/$MRC_FILE"

# Ryno UI Launcher
RYNO_UI_PATH="$ASSETS_DIR/$RYNO_UI_FILE"


# A special wine version is required to install .net dependencies
DOTNET_WINE_VERSION="wine-1.9.19 (Staging)"


###
### Configuration
###
### These won't get used until I can figure out how to edit a registry file from
### the command line...
###

# SCREEN_WIDTH="1920"
# SCREEN_HEIGHT="1080"
