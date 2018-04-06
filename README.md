# Halo PC on Ubuntu/Linux Mint

## Prerequisites

### Install Playonlinux

`sudo apt install -y playonlinux`


### Install dependencies for Halo CE Single Player

`sudo apt install -y git`


### Clone this repository

It will be easiest, especially for beginners, to use a dedicated directory when running the install script.  For the purposes of illustration, I will assume you have cloned this repository in `~/halo_pc_on_linux`, and you have placed the files you will download below into the `assets` folder.  Here are the commands I recommend you use:

1. `cd`
1. `git clone https://github.com/brainthinks/halo_pc_on_linux.git`
1. `mkdir -p halo_pc_on_linux/assets`


### .NET Framework

Download the .NET Framework 4.5.1 from Microsoft:

[https://www.microsoft.com/en-au/download/details.aspx?id=40779](https://www.microsoft.com/en-au/download/details.aspx?id=40779)

Move the downloaded file to `~/halo_pc_on_linux/assets`


### Halo 1.0.10 Patch

Bungie was kind enough to not only release updates and patch Halo PC to not need the CD to be inserted, but they are kind enough to STILL host these files on their website, 14+ years later!

[https://www.bungie.net/en-us/Forums/Post/64943622?page=0&sort=0&showBanned=0&path=0](https://www.bungie.net/en-us/Forums/Post/64943622?page=0&sort=0&showBanned=0&path=0)

The specific links you need will have the text:

* `Halo PC 1.0.10`
* `Halo CE 1.0.10`

but I recommend downloading all 4 files, because there's no telling how long they will actually be available.  Also, if you plan on installing SPV3, you will need the CE rather than the PC patch.

Here are the direct links:

* Halo PC 1.0.10 - [http://halo.bungie.net/images/games/halopc/patch/110/halopc-patch-1.0.10.exe](http://halo.bungie.net/images/games/halopc/patch/110/halopc-patch-1.0.10.exe)
* Halo CE 1.0.10 - [http://halo.bungie.net/images/games/halopc/patch/110/haloce-patch-1.0.10.exe](http://halo.bungie.net/images/games/halopc/patch/110/haloce-patch-1.0.10.exe)
* Halo PC Dedicated Server 1.0.10 - [http://halo.bungie.net/images/games/halopc/patch/110/haloded.exe](http://halo.bungie.net/images/games/halopc/patch/110/haloded.exe)
* Halo CE Dedicated Server 1.0.10 - [http://halo.bungie.net/images/games/halopc/patch/110/haloceded.exe](http://halo.bungie.net/images/games/halopc/patch/110/haloceded.exe)

Move the downloaded files to `~/halo_pc_on_linux/assets`


### Halo Custom Edition

[http://hce.halomaps.org/index.cfm?fid=410](http://hce.halomaps.org/index.cfm?fid=410)

Move the downloaded file to `~/halo_pc_on_linux/assets`


### OpenSauce

[http://www.halomods.com/ips/index.php?/topic/848-opensauce-v400-release/](http://www.halomods.com/ips/index.php?/topic/848-opensauce-v400-release/)

Move the downloaded file to `~/halo_pc_on_linux/assets`


### Ryno UI

If you plan on playing the single player campaign in Halo CE (which is the way I recommend playing it), you will need a `ui.map` file that allows you to play the campaign.  Ryno UI is the closest I found to stock.  You are free to use your own `ui.map` file, but this guide assumes you are using this one.

[http://hce.halomaps.org/index.cfm?fid=6382](http://hce.halomaps.org/index.cfm?fid=6382)

Move the downloaded file to `~/halo_pc_on_linux/assets`


## Configure Playonlinux and Wine

### Get the latest wine staging version

1. Ensure you have Playonlinux open
1. Click the "Tools" menu
1. Click "Manage Wine Versions"
1. Ensure you are on the "Wine versions (x86)" tab - these are the 32 bit wine versions
1. Highlight the latest version that ends with the word "staging".  At the time I wrote this, that was `2.21-staging`.
1. Click on the arrow in the middle that points to the right
1. This will bring up a dialog box - click "Next"
1. Once the download completes, close the "Wine Versions Manager" window

### Create a new virtual drive in Playonlinux

1. Ensure you have Playonlinux open
1. Click "Configure"
1. Click the "New" button at the bottom left
1. This will bring up a dialog box - click "Next"
1. Ensure "32 bits windows installation" is highlighted, then click "Next"
1. Find the latest version of wine staging from the list (which is probably all the way at the bottom), click it, then click "Next"
1. Type a name for this virtual drive - I used "halo_pc", then click "Next"
1. The virtual drive will now go through the setup steps.  You may be prompted a few times to take an action.  Anytime you are prompted, choose the affirmative option.  Here are a few examples:
    * "Wine Mono Installer" - click "Install"
    * "Wine Gecko Installer" - click "Install"
    * If none of those show up, that's fine, too

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


### Prepare the Virtual Drive

1. Copy and rename the configuration file:
    1. `cp ~/halo_pc_linux/config.example.sh ~/halo_pc_linux/config.sh`
1. Open the file `~/halo_pc_linux/config.sh` in a text editor, and ensure the values of the variables are correct.  If you followed this guide and did not change the names of any of the files you downloaded, you shouldn't have to change anything.
1. Ensure you have Playonlinux open, and you have selected the "halo_pc" virtual drive from the "Configuration" window
1. Click the "Miscellaneous" tab
1. Click "Open a shell" - This will open a terminal that is configured to use the wine version that is being managed in your "halo_pc" virtual drive
1. From this shell/terminal:
    1. `cd ~/halo_pc_on_linux`
    1. `./installer.sh`
1. Choose the first option to install dependencies by typing "1" then pressing enter.
    1. You will be prompted to type "yes" then hit enter
    1. Some installation windows will open then quickly disappear - this is normal
    1. You will again be prompted to type "yes" then hit enter
1. Exit by typing "6" then pressing enter.
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


## Install Halo!

1. Ensure you have Playonlinux open, and you have selected the "halo_pc" virtual drive from the "Configuration" window
1. Click the "Miscellaneous" tab
1. Click "Open a shell" - This will open a terminal that is configured to use the wine version that is being managed in your "halo_pc" virtual drive
1. From this shell/terminal:
    1. `cd ~/halo_pc_on_linux`
    1. `./installer.sh`
1. Choose which installations you would like to perform.  See the descriptions of each option below.
1. Exit.


### Install Dependencies

Before you can install any version of Halo, you will need to install the system dependencies.  Run this option first if you haven't already.


### Install Halo CE

You probably want to install this.  To use anything else below, except for a standalone Halo PC, you will need to have Halo CE installed.

After installing Halo CE, go back to the terminal and press enter.  This will start the installation of OpenSauce.


### Install Halo PC

If you have an ISO of the original Halo PC game, you can install Halo PC.  Note that it hasn't aged perfectly, so if you are looking to play the original game, I recommend you install Halo CE, Halo PC, and Halo CE Single Player.

When you have finished installing Halo PC, go back to the terminal and press enter, which will initiate the installation of the patch.


### Install Halo CE Single Player

After you've installed both Halo CE and Halo PC, you can install the single player campaign for Halo CE.  This will convert the Halo PC maps to work in Halo CE and install Ryno UI so you can access the campaign from Halo CE.


### Install SPV3

After you've installed Halo CE, you can install SPV3.


### Exit

Choose this last option when you're done.  This will exit the installer.


## Shortcuts

Now that you've installed the games you want to play, it's time to create the shortcuts to the game so you can actually play it.


### Create Shortcuts

1. Ensure you have Playonlinux open, and you are on the "Configuration" window that lists all of your virtual drives
1. Find your "halo_pc" virtual drive from the list on the left, then click it
1. Click the "General" tab
1. Click the "Make a new shortcut from this virtual drive" button
1. Scroll down to find and select either "haloce.exe" (Halo CE) or "halo.exe" (Halo PC) or both (do not use the .lnk files)
1. Click "Next"
1. Name the shortcut, then click "Next"
1. When you're done making shortcuts, choose "I don't want to make another shortcut"
1. Click "Next"


### Configure Shortcuts

Note that you aren't necessarily required to run the game in fullscreen 1920x1080, but I have found it to be the most
stable way to play the game.

1. Ensure you have Playonlinux open, and you are on the "Configuration" window that lists all of your virtual drives
1. Find your "halo_pc" virtual drive from the list on the left, then click it
1. Find the shortcut you made for Halo PC or Halo CE, then click it
1. In the "Arguments" text box, put the following after anything that might already be in there.  Note that it starts with a space:
    1. `-vidmode 1920,1080,60 -console`
1. Repeat this for any additional Halo shortcuts


## References

* [https://www.bungie.net/en-us/Forums/Post/64943622?page=0&sort=0&showBanned=0&path=0](https://www.bungie.net/en-us/Forums/Post/64943622?page=0&sort=0&showBanned=0&path=0)
* [http://www.pcgamer.com/how-to-run-halo-combat-evolved-on-windows-78/](http://www.pcgamer.com/how-to-run-halo-combat-evolved-on-windows-78/)
* [http://halo.wikia.com/wiki/Halo_Custom_Edition](http://halo.wikia.com/wiki/Halo_Custom_Edition)
* [http://hce.halomaps.org/index.cfm?fid=410](http://hce.halomaps.org/index.cfm?fid=410)
* [http://www.halomods.com/ips/index.php?/topic/848-opensauce-v400-release/](http://www.halomods.com/ips/index.php?/topic/848-opensauce-v400-release/)
* [https://www.reddit.com/r/halospv3/comments/50wzck/tutorial_noobs_guide_to_spv3_on_fedora_24/](https://www.reddit.com/r/halospv3/comments/50wzck/tutorial_noobs_guide_to_spv3_on_fedora_24/)
* [https://social.msdn.microsoft.com/Forums/vstudio/en-US/954947f6-1167-4994-93a1-0cdf3f1d8683/dot-net-framework-35-sp1-offline-installer?forum=netfxsetup](https://social.msdn.microsoft.com/Forums/vstudio/en-US/954947f6-1167-4994-93a1-0cdf3f1d8683/dot-net-framework-35-sp1-offline-installer?forum=netfxsetup)
* [http://www.gearboxsoftware.com/game/halo-combat-evolved/](http://www.gearboxsoftware.com/game/halo-combat-evolved/)
* [http://hce.halomaps.org/hek/index.html?start=references/general/console_commands.html](http://hce.halomaps.org/hek/index.html?start=references/general/console_commands.html)
* [https://www.manageengine.com/products/desktop-central/software-installation/silent_install_Microsoft-.NET-Framework-4.5.1.html](https://www.manageengine.com/products/desktop-central/software-installation/silent_install_Microsoft-.NET-Framework-4.5.1.html)
* [https://opencarnage.net/index.php?/topic/4680-combustion-203/](https://opencarnage.net/index.php?/topic/4680-combustion-203/)
* [http://hce.halomaps.org/index.cfm?fid=6382](http://hce.halomaps.org/index.cfm?fid=6382)
* [https://web.archive.org/web/20160618210404/http://uni-smr.ac.ru/archive/win/MS%20.NET%20Framework/3.0/dotnetfx3.exe](https://web.archive.org/web/20160618210404/http://uni-smr.ac.ru/archive/win/MS%20.NET%20Framework/3.0/dotnetfx3.exe)
* [https://www.microsoft.com/en-us/download/details.aspx?id=3005](https://www.microsoft.com/en-us/download/details.aspx?id=3005)
* [https://www.bungie.net/en-US/Forums/Post/3066503?page=0&sort=0&showBanned=0&path=1](https://www.bungie.net/en-US/Forums/Post/3066503?page=0&sort=0&showBanned=0&path=1)
* [https://ubuntuforums.org/showthread.php?t=486986](https://ubuntuforums.org/showthread.php?t=486986)
* [https://ubuntuforums.org/showthread.php?t=655352](https://ubuntuforums.org/showthread.php?t=655352)
* [https://www.reddit.com/r/halospv3/comments/545mhs/spv302_released_download_for_all_users_inside/](https://www.reddit.com/r/halospv3/comments/545mhs/spv302_released_download_for_all_users_inside/)
* [https://www.youtube.com/watch?v=J0ANLxDdf_U](https://www.youtube.com/watch?v=J0ANLxDdf_U)


## @TODO

* use recurring prompts after the different installations finish
* add the maw fixed(?)
* Install SPV3!
