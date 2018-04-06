#!/usr/bin/env bash

# The place where you put all the downloaded files.  If you followed
# the guide from the README, you won't need to change this.
BASE_DIR="./assets"
TMP_DIR="/tmp/halo_pc_on_linux"

# The names of all of the files you downloaded.  If you didn't change
# the names of the files after you downloaded them, you won't need to
# change any of their names here.
DOTNET_451_PATH="$BASE_DIR/NDP451-KB2858728-x86-x64-AllOS-ENU.exe"
HALO_ISO_MOUNT_DIR="$TMP_DIR/HALO"
HALO_ISO_PATH="$BASE_DIR/HALO.ISO"
HALO_PC_PATCH_PATH="$BASE_DIR/halopc-patch-1.0.10.exe"
HALO_CE_PATH="$BASE_DIR/halocesetup_en_1.00.exe"
HALO_CE_PATCH_PATH="$BASE_DIR/haloce-patch-1.0.10.exe"
OPENSAUCE_PATH="$BASE_DIR/OpenSauce_Halo1_CE_20150302.msi"
RYNO_UI_PATH="$BASE_DIR/RynO_UI.zip"
VC_PATH="$BASE_DIR/vc_redist.x64.exe"
C_DRIVE_PATH="/home/$USER/.PlayOnLinux/wineprefix/halo_pc/drive_c"
