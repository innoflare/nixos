# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.initrd.kernelModules = [
    "vboxdrv"
  ];

  virtualisation.virtualbox.host.enable = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
   enable = true;
   version = 2;
   device = "/dev/sda";
   extraEntries = ''{
     menuentry 'Ubuntu'--class ubuntu --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-77953127-1b40-41f6-8992-fdec51648139' {
       set root='hd0,gpt3'
       linux   /boot/vmlinuz-4.4.0-21-generic root=UUID=c597286c-9ea7-452d-ac4d-2ec6c8460208 ro  quiet splash $vt_handoff
       initrd  /boot/initrd.img-4.4.0-21-generic
     }
    }'';
  };

  networking.hostName = "SuperBook"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  fileSystems = [
    { mountPoint = "/home";
      device = "/dev/sda7";
    }
  ];

  swapDevices = [
    { device = "/swapfile"; }
  ];

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";
  
  services.redshift = {
        enable = true;
        latitude = "-7.059402";
        longitude = "122.364087";
        brightness.day = "0.7";
        brightness.night = "0.4";
        extraOptions = [ "-m randr" ];
        temperature = {
            day = 5500;
            night = 3700;
        };     
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget

  nixpkgs.config = {

      allowUnfree = true;

      firefox = {
       enableAdobeFlash = true;
      }; 

      chromium = {
       enablePepperFlash = true;
      };

      icedtea = true;
      # virtualbox.enableExtensionPack = true;
    };

  environment.systemPackages = with pkgs; [
    wget
    linuxPackages.virtualbox
    chromium
    clementine
    vlc
    zsh
    rsync
    qbittorrent
    htop
    git
    sudo
    ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver = { 
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";
    synaptics.enable = true;
    vaapiDrivers = [ pkgs.vaapiIntel ];
    windowManager.i3.enable = true;
    # windowManager.i3.configFile = $HOME/.i3/config;
    displayManager.sddm.enable = true;
    desktopManager.kde5.enable = true;
  };

  hardware.pulseaudio.enable = true;
  # services.acpid.enable = true;
  powerManagement.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}
