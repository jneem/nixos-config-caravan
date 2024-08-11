# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    inputs.nixos-cosmic.nixosModules.default

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  time.timeZone="Asia/Bangkok";
  virtualisation.docker.enable = true;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.flake-inputs
      outputs.overlays.modifications
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  # Recent kernel fixed issues with power-off
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/" "https://nix-community.cachix.org" "https://cosmic.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" 
      ];
      trusted-users = ["root" "jneeman" ];
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  networking.hostName = "caravan";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [42000 42001];
  networking.firewall.allowedUDPPorts = [42000 42001];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  users.users = {
    jneeman = {
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [ "docker" "networkmanager" "wheel" "video" "scanner" "lp" "libvirtd" "dialout" "disk" "audio"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3Hjr4Dv+5hKLBzAxO83oiNHA0ZmaG0/LINPVOKs9+4"
      ];
    };
  };

  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  programs.sway.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  i18n = {
    defaultLocale = "en_US.utf8";
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-unikey fcitx5-gtk ];
    };
  };

  environment.systemPackages = with pkgs; [
    bat
    entr
    fd
    file
    fzf
    git
    gitui
    helix
    home-manager
    htop
    jq
    neovim
    nil
    p7zip
    ripgrep
    unzip
    vim
    wally-cli
    wget
    wl-clipboard
    xh
  ];

    
  programs.dconf.enable = true;
  programs.fish.enable = true;

  security.sudo = {
    enable = true;
    execWheelOnly = true;
  };
}
