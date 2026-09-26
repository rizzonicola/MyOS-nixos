# See configuration.nix(5) and `nixos-help` for details.

{ config, pkgs, ... }:

let
  unstable = import <unstable> {
    config = config.nixpkgs.config;
  };
in

{
  imports = [ ./hardware-configuration.nix ];

  ###########################################################################
  # BASE SYSTEM
  ###########################################################################

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Limit kept generations so nix-collect-garbage can actually free space.
  boot.loader.systemd-boot.configurationLimit = 10;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  system.stateVersion = "26.05";

  ###########################################################################
  # LOCALIZATION
  ###########################################################################

  time.timeZone = "Europe/Rome";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  services.xserver.xkb = {
    layout = "it";
    variant = "";
  };
  console.keyMap = "it2";

  ###########################################################################
  # DESKTOP / DISPLAY MANAGER
  ###########################################################################

  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;

  # greetd as the display manager, launching niri via tuigreet.
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd niri";
        user = "greeter";
      };
    };
  };

  programs.niri.enable = true;

  ###########################################################################
  # AUDIO
  ###########################################################################

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ###########################################################################
  # USERS
  ###########################################################################

  users.users."user" = {
    isNormalUser = true;
    description = "User";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  ###########################################################################
  # SERVICES & FEATURES
  ###########################################################################

  services.printing.enable = true;
  services.flatpak.enable = true;

  # Needed to run non-NixOS binaries out of the box (AppImages, etc.).
  services.envfs.enable = true;
  programs.nix-ld.enable = true;

  # programs.gnupg.agent.enable = true;
  # services.openssh.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.enable = false;

  ###########################################################################
  # SYSTEM PACKAGES
  ###########################################################################

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    appimage-run
    gnumake
    gcc
    xwayland
    xwayland-satellite
    qt6.qtwayland
    wl-clipboard
    brave
    onlyoffice-desktopeditors
    vlc
    ghostty
    nwg-displays
    nwg-look
    
    # Cursors and icons
    bibata-cursors
    capitaine-cursors
    papirus-icon-theme

    # Unstable
    unstable.noctalia
  ];

  ###########################################################################
  # NIX STORE / GARBAGE COLLECTION
  ###########################################################################

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Weekly GC; only effective if old system generations are capped (see above).
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;
}
