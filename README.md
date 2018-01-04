# Halo PC on Ubuntu/Linux Mint

## Prerequisites

### Playonlinux

`sudo apt install -y playonlinux winetricks`

### Clone this repository

It will be easiest, especially for beginners, to use a dedicated directory when running the install script.  For the purposes of illustration, I will assume you have cloned this repository in `~/halo_pc_on_linux`, and you have placed the files you will download below into the `assets` folder.  Here are the commands I recommend you use:

1. `cd`
1. `git clone https://github.com/brainthinks/halo_pc_on_linux.git`
1. `mkdir -p halo_pc_on_linux/assets`


### .NET Framework

Download the .NET Framework 4.5.1 from Microsoft:

["https://www.microsoft.com/en-au/download/details.aspx?id=40779"](https://www.microsoft.com/en-au/download/details.aspx?id=40779)

Move the downloaded file to `~/halo_pc_on_linux/assets`


### Halo 1.0.10 Patch

Bungie was kind enough to not only release updates and patch Halo PC to not need the CD to be inserted, but they are kind enough to STILL host these files on their website, 14+ years later!

["https://www.bungie.net/en-us/Forums/Post/64943622?page=0&sort=0&showBanned=0&path=0"](https://www.bungie.net/en-us/Forums/Post/64943622?page=0&sort=0&showBanned=0&path=0)

The specific links you need will have the text:

`Halo PC 1.0.10`
`Halo CE 1.0.10`

but I recommend downloading all 4 files, because there's no telling how long they will actually be available.  Also, if you plan on installing SPV3, you will need the CE rather than the PC patch.

Here are the direct links:

* Halo PC 1.0.10 - ["http://halo.bungie.net/images/games/halopc/patch/110/halopc-patch-1.0.10.exe"](http://halo.bungie.net/images/games/halopc/patch/110/halopc-patch-1.0.10.exe)

* Halo CE 1.0.10 - ["http://halo.bungie.net/images/games/halopc/patch/110/haloce-patch-1.0.10.exe"](http://halo.bungie.net/images/games/halopc/patch/110/haloce-patch-1.0.10.exe)

* Halo PC Dedicated Server 1.0.10 - ["http://halo.bungie.net/images/games/halopc/patch/110/haloded.exe"](http://halo.bungie.net/images/games/halopc/patch/110/haloded.exe)

* Halo CE Dedicated Server 1.0.10 - ["http://halo.bungie.net/images/games/halopc/patch/110/haloceded.exe"](http://halo.bungie.net/images/games/halopc/patch/110/haloceded.exe)

Move the downloaded files to `~/halo_pc_on_linux/assets`


### Halo Custom Edition

["http://hce.halomaps.org/index.cfm?fid=410"](http://hce.halomaps.org/index.cfm?fid=410)

Move the downloaded file to `~/halo_pc_on_linux/assets`


### OpenSauce

["http://www.halomods.com/ips/index.php?/topic/848-opensauce-v400-release/"](http://www.halomods.com/ips/index.php?/topic/848-opensauce-v400-release/)

Move the downloaded file to `~/halo_pc_on_linux/assets`


## Do this stuff

### Get the latest wine staging version

1. Ensure you have Playonlinux open
1. Click the "Tools" menu
1. Click "Manage Wine Versions"
1. Ensure you are on the "Wine versions (x86)" tab - these are the 32 bit wine versions
1. Highlight the latest version that ends with the word "staging".  At the time I wrote this, that was `2.21-staging`.
1. Click on the arrow in the middle that points to the right
1. This will bring up a dialog box - click "Next"
1. Close the "Wine Versions Manager" window

### Create a new virtual drive in Playonlinux

1. Ensure you have Playonlinux open
1. Click "Configure"
1. Click the "New" button at the bottom left
1. This will bring up a dialog box - click "Next"
1. Ensure "32 bits windows installation" is highlighted, then click "Next"
1. Find the latest version of wine staging from the list, click it, then click "Next"
1. Type a name for this virtual drive - I used "halo_pc", then click "Next"
1. The virtual drive will now go through the setup steps.  You may be prompted a few times to take an action.  Anytime you are prompted, choose the affirmative option.  Here are a few examples:
    * "Wine Mono Installer" - click "Install"
    * "Wine Gecko Installer" - click "Install"

### Configure the virtual drive

1. Ensure you have Playonlinux open, and you are on the "Configuration" window that lists all of your virtual drives
1. Find your "halo_pc" virtual drive from the list on the left, then click it
1. Click the "Wine" tab
1. Click "Configure Wine"
1. This will open a "Wine configuration" window that looks like a Windows configuration window
    1. From the "Applications" tab, ensure the "Windows Version" is set to "Windows 7"
    1. From the "Libraries" tab:
        1. Type "dinput8" into the "New override for library" dropdown
        1. Click the "Add" button
    1. From the "Staging" tab:
        1. Check "Enable CMST for better graphic performance"
    1. Click OK

### Run the interactive Installer

1. Ensure you have Playonlinux open, and you have selected the "halo_pc" virtual drive from the "Configuration" window
1. Click the "Miscellaneous" tab
1. Click "Open a shell" - This will open a terminal that is configured to use the wine version that is being managed in your "halo_pc" virtual drive
1. From this shell/terminal:
    1. `cd ~/halo_pc_on_linux`
    1. `./install.sh`

### Configure the virtual desktop

1. Ensure you have Playonlinux open, and you have selected the "halo_pc" virtual drive from the "Configuration" window
1. Click the "Wine" tab
1. Click "Configure Wine"
1. This will open a "Wine configuration" window that looks like a Windows configuration window
    1. From the "Graphics" tab:
        1. Check "Automatically capture the mouse in full-screen windows"
        1. Uncheck "Allow the window manager to decorate windows"
        1. Uncheck "Allow the window manager to control the windows"
        1. Check "Emulate a virtual desktop"
        1. Set the "Desktop size" to 1920 x 1080 (or another resolution if you prefer)
    1. Click OK




## OLD steps:

### Install DirectX9

1. Ensure you have Playonlinux open, and you have selected the "halo_pc" virtual drive from the "Configuration" window
1. Click the "Install components" tab
1. Scroll down until you find "d3dx9_36", then click on it, then click "Install"
1. A dialog box will pop open then close, indicating that the installation has completed
1. Verify that DirectX9 is installed:
    1. Click the "Wine" tab
    1. Click "Configure Wine"
    1. Click the "Libraries" tab
    1. In the "Existing overrides" section, you should see "\*d3dx9_36 (native, builtin)"

### Install Dependencies

1. Ensure you have Playonlinux open, and you have selected the "halo_pc" virtual drive from the "Configuration" window
1. Click the "Miscellaneous" tab
1. Click "Open a shell" - This will open a terminal that is configured to use the wine version that is being managed in your "halo_pc" virtual drive
1. `winetricks msxml4 mfc42`
    1. Click "Next"
    1. Ensure "I accept the terms in the License Agreemnt" is selected, then click "Next"
    1. Click "Next" - you do not need to enter any information
    1. Click "Install Now"
    1. Click "Finish"
    1. Click "Ia"
1. `winetricks dotnet40`
    1. You will be prompted to download a file from MediaFire.  Unfortunately, this is a manual step.
    1. Winetricks will have instructional text about putting the file in a specific directory - you will need to do this.  Here are the commands I ran after downloading the installer:
    1. `mv ~/Downloads/gacutil-net40.tar.bz2 ~/halo_pc_linux/gacutil-net40.tar.bz2`
    1. `cp ~/halo_pc_linux/gacutil-net40.tar.bz2 ~/.cache/winetricks/dotnet40/gacutil-net40.tar.bz2`
    1. `winetricks dotnet40`
    1. Check "I have read and accept the license terms.", then click "Install"
    1. Click "Finish"


1. `cd ~/halo_pc_linux`
1. Use `wine` to execute the .NET Framework installer.  Note that your filename may be different:
    1. `wine NDP451-KB2858728-x86-x64-AllOS-ENU.exe`
    1. This will launch wine, which will result in your screen becoming blue, with the .NET Framework installer running
    1. You will receive a warning about Windows Update - click "Continue"
    1. Check the box that says "I have read and accept the license terms" then click "Install"
    1. Click "Finish"

### Install Halo PC

1. Use your Halo PC disk to create a disk image.
    1. Note that you may simply be able to drag the files off of the disk into a folder, but I did not try this.  Please let me know if you have success with this method.
    1. If you do not know how to create a disk image, use google and duckduckgo.  I personally used Alcohol 120% on Windows, but you may rip the image however you see fit.  The disk does have some copy protection, so you may need to enable the "skip read errors" option in your imaging software.
1. Ensure you have a serial
    1. I still have my Halo PC disk, so I have my own serial.  If you do not, use google and duckduckgo.
1. Make the Halo PC installation files accessible
    1. If you simply pulled all of the files from the disk, you should already have all files ready for the next step.
    1. If you have an image file (iso, bin/bue, etc.), you can try extracting it, but this did not work for me - the archive manager was not able to detect any files.
    1. I personally used the "Disk Image Mounter" option in Linux Mint.  Right click on the image file (which for me was an iso), and "Disk Image Mounter" is the first option in the menu.  This will mount the image, and it will show up in your "Devices" list in your file manager on the left.  Click on the mounted image to get the path to it.  For me, it was `/media/$USER/HALO`.
1. Ensure you have Playonlinux open, and you have selected the "halo_pc" virtual drive from the "Configuration" window
1. Click the "Miscellaneous" tab
1. Click "Open a shell"
1. `cd /media/$USER/HALO` (note that the path to your Halo PC installation files may be different)
1. `wine Setup.Exe` - this will launch the Halo PC installer!
1. Click "Install"
1. Enter your serial number, then click "Next"
1. Click "Next"
1. Click "Install"
1. Once installation has finished, close the installer window
1. Note that the shell/terminal you have open may not be aware that you have finished the installation.  Press Ctrl+c to kill the process.
1. Install 1.0.10 patch
    1. In the same shell/terminal, `cd ~/halo_pc_linux`
    1. `wine halopc-patch-1.0.10.exe`
    1. When the patch is done installing, click "OK"
1. Note that the shell/terminal you have open may not be aware that you have finished the installation.  Press Ctrl+c to kill the process.
1. `exit` - exit the shell

### Create shortcut for Halo

1. Ensure you have Playonlinux open, and you have selected the "halo_pc" virtual drive from the "Configuration" window
1. Ensure you are on the "General" tab
1. Click "Make a new shortcut from this virtual drive"
1. Find "halo.exe", click it, then click "Next"
1. Change the shortcut name if you want, then click "Next"
1. Click "I don't want to make another shortcut", then click "Next"

### Get Halo running fullscreen

This is trickier than you might think.  Halo is an old game, and it was not made to run at 1920 x 1080, or even in widescreen!  Additionally, fullscreen games in wine require a bit more care than a standard windowed Windows application.  There is no resolution setting of 1920x1080 or higher from within the game menu, so here are the steps to configure it manually.

1. From the main Playonlinux window, choose the shortcut for Halo you just created, then click "Configure"
1. You should now see the details of the Halo shortcut.  In the "Arguments" field, enter "-vidmode 1920,1080,60"
1. Close the "Playonlinux configuration" window
1. From the main Playonlinux window, choose the shortcut for Halo you just created, then run it
1. You will be presented with the EULA - click "Accept"
1. Halo should now be running in fullscreen at the proper resolution!  You are now playing vanilla Halo PC on Linux!

I found it difficult to play the game though - the HUD is partially off screen, the image is stretched because it's not running at 16:9, and it looks zoomed in.  However, this is the default Halo PC experience, so I thought it may be useful or nostalgic for someone looking to play the game strictly as it was originally designed (with the exception of it running on Windows, of course).

I personally do not want to stop here though, because the Halo community has kept the game alive with various tools and content.  At the very least, I want to play Halo PC with the HUD fully visible and an aspect ratio of 16:9.


### "Modernize" Halo PC

Because Halo is old and no longer updated by Bungie, it will not run using "modern" settings.  Thankfully, Bungie and Gearbox were kind enough to create an API for their engine, which allows the community to create custom content.  Also thankfully, the community has put significant effort into creating tools that have enhanced Halo in more ways than I know about, to allow gamers today to experience Halo, and not have it feel as old as it could.  So a special thanks to Bungie, Gearbox, the halomods.com community, Masterz1337, and others for keeping Halo alive and fresh for so many years.

#### Halo Custom Edition

1. Ensure you have Playonlinux open, and you have selected the "halo_pc" virtual drive from the "Configuration" window
1. Click the "Miscellaneous" tab
1. Click "Open a shell"
1. `cd ~/halo_pc_linux`
1. `wine halocesetup_en_1.00.exe`
1. Click "Accept"
1. Click "Install"
1. Enter your serial, then click "Next"
1. Click "Next"
1. Click "Install"
1. Once installation has finished, close the installer window
1. Note that the shell/terminal you have open may not be aware that you have finished the installation.  Press Ctrl+c to kill the process.
1. `wine haloce-patch-1.0.10.exe`
1. Note that the shell/terminal you have open may not be aware that you have finished the installation.  Press Ctrl+c to kill the process.
1. `exit` - close the shell

#### Halo Custom Edition Shortcut

1. Ensure you have Playonlinux open, and you have selected the "halo_pc" virtual drive from the "Configuration" window
1. Click the "General" tab
1. Click "Make a new shortcut from this virtual drive"
1. Find "haloce.exe", click it, then click "Next"
1. Change the shortcut name if you want, then click "Next"
1. Click "I don't want to make another shortcut", then click "Next"
1. Click on the haloce shortcut you just made on the list on the left
1. You should now see the details of the Halo shortcut.  In the "Arguments" field, enter "-vidmode 1920,1080,60"

#### OpenSauce

1. Ensure you have Playonlinux open, and you have selected the "halo_pc" virtual drive from the "Configuration" window
1. Click the "Miscellaneous" tab
1. Click "Open a shell"
1. `cd ~/halo_pc_linux`
1. Install .NET framework 3.5
    1. `winetricks dotnet35`
    1. You will be prompted to download .NET 3.0 from oldversion.  Unfortunately, this is a manual step.
    1. Winetricks will have instructional text about putting the .NET installer in a specific directory - you will need to do this.  Here are the commands I ran after downloading the .NET 3.0 installer:
    1. `mv ~/Downloads/netframework3.exe ~/halo_pc_linux/netframework3.exe`
    1. `cp ~/halo_pc_linux/netframework3.exe ~/.cache/winetricks/dotnet30/netframework3.exe`
    1. `winetricks -q --force dotnet35`
    1. Type "Yes", then hit enter, when prompted to delete a registry key
    1. Installation will take a few minutes
1. `msiexec /i OpenSauce_Halo1_CE_20150302.msi`
1. Click "Next"
1. Check "I accept the terms in the License Agreement", then click "Next"
1. Click "Next"



1. You can run the shortcut if you like to confirm that it works and to create a profile
1.


## References


https://www.bungie.net/en-us/Forums/Post/64943622?page=0&sort=0&showBanned=0&path=0
http://www.pcgamer.com/how-to-run-halo-combat-evolved-on-windows-78/
http://halo.wikia.com/wiki/Halo_Custom_Edition
http://hce.halomaps.org/index.cfm?fid=410
http://www.halomods.com/ips/index.php?/topic/848-opensauce-v400-release/
https://www.reddit.com/r/halospv3/comments/50wzck/tutorial_noobs_guide_to_spv3_on_fedora_24/
https://social.msdn.microsoft.com/Forums/vstudio/en-US/954947f6-1167-4994-93a1-0cdf3f1d8683/dot-net-framework-35-sp1-offline-installer?forum=netfxsetup
http://www.gearboxsoftware.com/game/halo-combat-evolved/
http://hce.halomaps.org/hek/index.html?start=references/general/console_commands.html
https://www.manageengine.com/products/desktop-central/software-installation/silent_install_Microsoft-.NET-Framework-4.5.1.html
