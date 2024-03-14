# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  # Enable the cron service
  services.cron = {
    enable = true;
    systemCronJobs = [
      "55 23 * * *      liviu    /bin/sh -c '/home/liviu/build-plex.sh'"
      "*/1 * * * * 	liviu 	 /bin/sh -c '/home/liviu/plexcheck.sh'"
    ];
  };
  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {"vm.swappiness" = 10;};

  boot.loader.timeout = 15;
  #swapDevices = lib.mkForce [];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.liviu = {
    isNormalUser = true;
    description = "liviu";
    extraGroups = ["networkmanager" "wheel" "docker"];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsn7g4+Tby+VLeKrHLmecuuCaR3De/ONC+tICGE2MnE marialiviuvalentin@gmail.com"];
    packages = with pkgs; [
      firefox
      kate
      vim
      yakuake
      alejandra
      git
      vlc
      wget
      htop
      signal-desktop
      telegram-desktop
      qbittorrent
      partition-manager
      #whatsapp-for-linux
      #  thunderbird
      #rbenv
      #ruby_3_3
    ];
  };
  virtualisation.docker.enable = true;
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "liviu";
  };

  fileSystems."/home/liviu/mediaDisk" = {
    device = "UUID=8fdf5716-93f9-469a-a7b4-498787d68d38";
    fsType = "ext4";
    options = ["defaults"]; # Changed to a list
  };

  fileSystems."/home/liviu/NtfsMediaDisk" = {
    device = "UUID=1A648B9C648B78F1";
    fsType = "ntfs";
    options = ["defaults"]; # Changed to a list
  };

  fileSystems."/home/liviu/external2T" = {
    device = "UUID=9de90352-42d8-4ca9-9814-1f1a29710f65";
    fsType = "ext4";
    options = ["defaults"]; # Changed to a list
  };
  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "liviu";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
  programs.vim = {
    defaultEditor = true;
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [32400 8096 24448];
  networking.firewall.allowedUDPPorts = [32400 8096 24448];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
