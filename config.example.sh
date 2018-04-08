#!/usr/bin/env bash

# This isn't used, but you can track your serial number here if you'd like
SERIAL=""

###
### Configuration
###
### These won't get used until I can figure out how to edit a registry file from
### the command line...
###

# SCREEN_WIDTH="1920"
# SCREEN_HEIGHT="1080"


###
### File Names
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
### Directories
###
### Unless you're doing something custom, you don't need to change these.  You
### are more likely to need to change settings in the "Configuration" and
### "File Names" sections.
###

# So we can get back to home
PROJECT_DIR=$(pwd)

# A special wine version is required to install .net dependencies
DOTNET_WINE_VERSION="wine-1.9.19 (Staging)"

# The place where you put all the downloaded files.  If you followed
# the guide from the README, you won't need to change this.
ASSETS_DIR="$PROJECT_DIR/assets"

# The place where extracted files will be temporarily stored
TMP_DIR="/tmp/halo_pc_on_linux"

# Paths to the Halo CE Maps
PATH_TO_C_DRIVE="$WINEPREFIX/drive_c"
PATH_TO_CE_MAPS="$PATH_TO_C_DRIVE/Program Files/Microsoft Games/Halo Custom Edition/maps"
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

# Identification files
PATH_TO_CE_ID=".haloce"
PATH_TO_SPV3_ID=".spv3"
PATH_TO_MRC_ID=".mrc"
PATH_TO_PCC_ID=".pcc"


###
### File Paths
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
