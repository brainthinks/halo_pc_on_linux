# Halo PC on Ubuntu/Linux Mint

This was tested on Linux Mint 18 / Ubuntu 16.04

## Prerequisites

### Install System Dependencies

```bash
sudo apt install -y \
    playonlinux \
    git \
    p11-kit-modules:i386
```


### Clone this repository

It will be easiest, especially for beginners, to use a dedicated directory when running the install script.  For the purposes of illustration, I will assume you have cloned this repository in `~/halo_pc_on_linux`, and you have placed the files you will download below into the `assets` folder.  Here are the commands I recommend you use:

```bash
# This will take you to your home folder aka ~
cd

# This will clone this repository, which means the source code will be downloaded to your computer
git clone "https://github.com/brainthinks/halo_pc_on_linux.git"

# This will create a folder that we'll be putting some files in
mkdir -p "halo_pc_on_linux/assets"
```


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


### SPV3

Follow the official download instructions - [https://www.reddit.com/r/halospv3/comments/6umz3f/spv31_released_all_new_install_method_11_missions/](https://www.reddit.com/r/halospv3/comments/6umz3f/spv31_released_all_new_install_method_11_missions/)

Direct Link - [http://www.mediafire.com/file/jy6nfbnrwnqhtb9/SPV3.1.0f.zip](http://www.mediafire.com/file/jy6nfbnrwnqhtb9/SPV3.1.0f.zip)

Move the downloaded file to `~/halo_pc_on_linux/assets`


### Ryno UI

If you plan on playing the single player campaign in Halo CE (which is the way I recommend playing it), you will need a `ui.map` file that allows you to play the campaign.  Ryno UI is the closest I found to stock.  You are free to use your own `ui.map` file, but this guide assumes you are using this one.

[http://hce.halomaps.org/index.cfm?fid=6382](http://hce.halomaps.org/index.cfm?fid=6382)

Move the downloaded file to `~/halo_pc_on_linux/assets`


### Mo's Refined Campaign

Here is the original thread: [http://forum.halomaps.org/index.cfm?page=topic&topicID=50277](http://forum.halomaps.org/index.cfm?page=topic&topicID=50277)

Click the download link at the top of the first post, which will take you to a google drive folder.  From here, click the dropdown icon at the end of the "Shared with me > halo ce fixed sp campaign".  Choose the "Download" option.  This will prompt you to download a big zip file.

Move the downloaded file to `~/halo_pc_on_linux/assets`, and rename it `mrc.zip`


## Configure Playonlinux and Wine

### Get the necessary wine versions

1. Ensure you have Playonlinux open
1. Click the "Tools" menu
1. Click "Manage Wine Versions"
1. Ensure you are on the "Wine versions (x86)" tab - these are the 32 bit wine versions
1. Highlight the latest 3.x version.  At the time I wrote this, that was `3.5`.  This is the wine version that halo will run in.
1. Click on the arrow in the middle that points to the right
1. This will bring up a dialog box - click "Next"
1. Wait for the download to complete
1. Highlight 1.9.19-staging - we need this one to install .net dependencies
1. Click on the arrow in the middle that points to the right
1. This will bring up a dialog box - click "Next"
1. Wait for the download to complete
1. close the "Wine Versions Manager" window

### Create a new virtual drive in Playonlinux

1. Ensure you have Playonlinux open
1. Click "Configure"
1. Click the "New" button at the bottom left
1. This will bring up a dialog box - click "Next"
1. Ensure "32 bits windows installation" is highlighted, then click "Next"
1. Find the 1.9.19-staging version of wine, click it, then click "Next"
1. Type a name for this virtual drive - I used "halo_pc", then click "Next"
1. The virtual drive will now go through the setup steps.  You may be prompted a few times to take an action.  Anytime you are prompted, choose the affirmative option.  Here are a few examples:
    * "Wine Mono Installer" - click "Install"
    * "Wine Gecko Installer" - click "Install"
    * If none of those show up, that's fine, too

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
1. Choose the first option to install .net dependencies by typing "1" then pressing enter
    1. Some installation windows will open then quickly disappear - this is normal
1. Exit by typing the number that corresponds to the exit option, then press enter
1. Type `exit` in the playonlinux shell
1. From the "playonlinux configuration" window, ensure you have selected the "halo_pc" virtual drive from the "Configuration" window
1. Click the "General" tab
1. Click on the "Wine version" dropdown, and choose `3.5`
1. Click the "Miscellaneous" tab
1. Click "Open a shell" again - this will open a shell using the new wine 3.5 version
1. From this shell/terminal:
    1. `cd ~/halo_pc_on_linux`
    1. `./installer.sh`
1. Choose the second option to install the rest of the dependencies by typing "2" then pressing enter


## Install Halo

Once you have followed the above steps, you will have downloaded all of the necessary files, created the virtual drive, and installed the necessary dependencies.  Now it's time to install Halo!  There are a few choices, but you will likely at least want to install Halo CE.  Once you have installed what you want, you can open the Halo manager script.

Note that you must install Halo CE prior to installing everything else, except Halo PC.

Also note that you must install both Halo CE and Halo PC before installing the Halo PC Campaign for Halo CE.

1. Ensure you have Playonlinux open, and you have selected the "halo_pc" virtual drive from the "Configuration" window
1. Click the "Miscellaneous" tab
1. Click "Open a shell" - This will open a terminal that is configured to use the wine version that is being managed in your "halo_pc" virtual drive
1. From this shell/terminal:
    1. `cd ~/halo_pc_on_linux`
    1. `./installer.sh`
    1. Install the games you want


## Configure SPV3

SPV3 has more rigid requirements for working properly, due to its custom launcher.  Because of this, we cannot set the vidmode and other settings, like we do with the Halo CE and Halo PC shortcuts.  You will only have to do the following steps once.

1. Ensure you have installed SPV3
1. Launch the `SPV3 (no launcher)` shortcut
1. Create a profile by clicking on "Settings", typing a name, and clicking "OK" to save it
1. Quit Halo CE
1. Launch the `SPV3` shortcut
1. Click on the red text at the bottom that will allow you to enter a profile name
1. Enter your profile name
1. Click "Step 03: Save Profile"
1. The launcher will close
1. Launch the `SPV3` shortcut - this time, you'll see the real menu, but don't click on anything
1. Open `~/My Games/Halo CE/Halo_Settings.User.xml` in a text editor
    1. `nano ~/My Games/Halo CE/Halo_Settings.User.xml`
1. Under `<Video>`, you'll see <Enabled>false</Enabled>` - change that `false` to `true`
1. Under `<Developer>`, you'll see <Enabled>false</Enabled>` - change that `false` to `true` if you want access to the console
1. Save and close the file
    1. If you're using nano, ctrl+x then enter will save and exit
1. Open `~/My Games/Halo CE/Chimera_Settings.User.xml` in a text editor
    1. `nano ~/My Games/Halo CE/Chimera_Settings.User.xml`
1. Under `<Cinematic>`, you'll see <Enabled>false</Enabled>` - change that `false` to `true`
1. Save and close the file
    1. If you're using nano, ctrl+x then enter will save and exit
1. Go back to the SPV3 launcher that you still have open
1. Click "Launch SPV3" to play the game!


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
* [http://forum.halomaps.org/index.cfm?page=topic&topicID=50277](http://forum.halomaps.org/index.cfm?page=topic&topicID=50277)
* [https://appdb.winehq.org/objectManager.php?sClass=application&iId=2586](https://appdb.winehq.org/objectManager.php?sClass=application&iId=2586)
* [https://askubuntu.com/questions/370737/p11-kit-typical-problem-with-wine](https://askubuntu.com/questions/370737/p11-kit-typical-problem-with-wine)
* [https://www.playonlinux.com/en/topic-10534-Regarding_ptrace_scope_fatal_error.html](https://www.playonlinux.com/en/topic-10534-Regarding_ptrace_scope_fatal_error.html)
* [https://www.playonlinux.com/en/documentation.html](https://www.playonlinux.com/en/documentation.html)

## @TODO

* now that I know about playonlinux-bash, what else can be automated?
* automate the downloads of the necessary files
* learn how to configure chimera
* make the screen size configurable
* add the maw fixed(?)
* Use bash infinity?
