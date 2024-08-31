# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laslo-swift314"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  services.gnome.core-utilities.enable = true;
  services.gnome.tracker.enable = true;
  
  # These packages are included on purpose:
    #baobab      # disk usage analyzer
    #eog         # image viewer
    #evince      # document viewer
    #file-roller # archive manager
    #gnome-calculator 
    #gnome-calendar 
    #gnome-characters 
    #gnome-clocks 
    #gnome-contacts
    #gnome-screenshot
    #gnome-system-monitor
    #gnome-weather
    #gnome-disk-utility
    #pkgs.gnome-connections
    
  # Exclude these packages:
  environment.gnome.excludePackages = (with pkgs; [
    cheese      # photo booth
    epiphany    # web browser
    simple-scan # document scanner
    totem       # video player
    yelp        # help viewer
    geary       # email client
    seahorse    # password manager
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
  ]);

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents and add epson driver.
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr2 ];
  };
  
  # Printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    wireplumber.enable = true;
  };
  # Enable accelerated video playback
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lasloh = {
    isNormalUser = true;
    description = "Laslo Hauschild";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      thunderbird
      _1password-gui
      _1password
      nextcloud-client
      libreoffice-qt
      hunspell
      hunspellDicts.en_CA
      hunspellDicts.de_DE
      texliveFull
      vlc
      spotify
      ausweisapp
      geogebra6
      
      prismlauncher
      
      whatsapp-for-linux
      telegram-desktop
      signal-desktop
      discord
      thunderbird

      gimp
      lightworks
      digikam
      mariadb
      exiftool
      
      jetbrains-toolbox
      vscode
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = 
  let
    nix-software-center = import (pkgs.fetchFromGitHub {
      owner = "snowfallorg";
      repo = "nix-software-center";
      rev = "0.1.2";
      sha256 = "xiqF1mP8wFubdsAQ1BmfjzCgOD3YZf7EGWl9i69FTls=";
    }) {};
  in
  with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    nix-software-center
    nautilus-python
    gnome-text-editor
    gparted
    helvum
    
    gnomeExtensions.dash-to-dock
    gnomeExtensions.gsconnect
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.vitals
    gnomeExtensions.caffeine
    gnomeExtensions.control-blur-effect-on-lock-screen
    
    nix-ld
  ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "lasloh" ];
  };
  programs.nix-ld.enable = true;
  programs.java = { enable = true; package = pkgs.jdk21; };
  programs.firefox.nativeMessagingHosts.gsconnect = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.  
  networking.firewall = { 
    enable = true;
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedTCPPorts = [ 24727 ]; # AusweisApp
    allowedUDPPorts = [ 24727 ]; # AusweisApp
  }; 

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
