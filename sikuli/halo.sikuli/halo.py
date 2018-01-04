# A Sikuli script
# @see http://doc.sikuli.org/javadoc/

# @todo - get these values from the command line
installation_method = "install_halo_pc"
serial = ""
wait_timeout = 600

# Get the correct screen in a multi-monitor environment
def find_screen (target, title):
    i = 0
    while i < Screen.getNumberScreens():
        if (Screen(i).exists(target)):
            return Screen(i)
        i += 1

    raise Exception("Unable to find the screen containing " + title + "!")

def install_halo_pc ():
  target_screen = find_screen("halo_pc_1.png", "Halo PC Installer")

  # Start the installer
  target_screen.click(Pattern("halo_pc_1.png").targetOffset(-172,18))
  target_screen.wait("halo_pc_2.png", wait_timeout)
  target_screen.type(serial)
  target_screen.click(Pattern("halo_pc_2.png").targetOffset(-166,-23))
  target_screen.wait("halo_pc_3.png", wait_timeout)
  target_screen.click(Pattern("halo_pc_3.png").targetOffset(-166,-25))
  target_screen.wait("halo_pc_4.png", wait_timeout)
  target_screen.click(Pattern("halo_pc_4.png").targetOffset(-166,-25))
  target_screen.wait("halo_pc_5.png", wait_timeout)
  target_screen.click(Pattern("halo_pc_5.png").targetOffset(291,-212))

def install_halo_pc_patch ():
  target_screen = find_screen("halo_pc_patch_1.png", "Halo PC Patch Installer")

def install_halo_ce ():
  target_screen = find_screen("halo_ce_1.png", "Halo CE Installer")

def install_halo_ce_patch ():
  target_screen = find_screen("halo_ce_patch_1.png", "Halo CE Patch Installer")

def install_opensauce ():
  target_screen = find_screen("opensauce_1.png", "OpenSauce Installer")

def main ():
  if (installation_method == "install_halo_pc"):
    install_halo_pc()
  elif (installation_method == "install_halo_pc_patch"):
    install_halo_pc_patch()
  elif (installation_method == "install_halo_ce"):
    install_halo_ce()
  elif (installation_method == "install_halo_ce_patch"):
    install_halo_ce_patch()
  elif (installation_method == "install_opensauce"):
    install_opensauce()
  else:
    raise Exception("Unknown installation method of " + installation_method)

main()
