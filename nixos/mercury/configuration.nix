# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  pkgs,
  ...
}:
let keys = import ../../nixos/ssh-keys.nix; in
{
  imports = [
    # Modules from modules/nixos

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    # inputs.nixos-cosmic.nixosModules.default

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ../common.nix

    ../../users/jneeman.nix
    ../../users/bong.nix
    ../../users/chickpea.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.root.openssh.authorizedKeys.keys = [
    keys.user."jneeman@zeus"
    keys.user."jneeman@caravan"
  ];

  services.displayManager = {
    gdm = {
      enable = true;
      autoSuspend = false;
    };
    defaultSession = "gnome";
  };
  services.desktopManager.gnome.enable = true;

  time.timeZone="America/Chicago";
  # virtualisation.docker.enable = true;

  #boot.kernelPackages = pkgs.linuxPackages_6_14;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "mercury";
  networking.networkmanager.enable = true;
  # networking.firewall.allowedTCPPorts = [42000 42001];
  networking.firewall.allowedUDPPorts = [51871 51872];
  networking.firewall.checkReversePath = false;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser pkgs.epson-escpr2 ];

  services.fwupd.enable = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  programs.sway.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    bat
    #blender
    inputs.nixpkgs-stable.legacyPackages.${system}.blender
    cntr
    #darktable
    entr
    fd
    file
    firefox
    fzf
    git
    gitui
    helix
    home-manager
    htop
    inkscape
    jq
    #jujutsu
    neovim
    nil
    inputs.nixpkgs-stable.legacyPackages.${system}.openscad-unstable
    orca-slicer
    p7zip
    ripgrep
    unzip
    vim
    wget
    wireguard-tools
    wl-clipboard
    xh
    zed-editor
    zoom-us
  ];

  programs.dconf.enable = true;
  programs.fish.enable = true;

  security.sudo = {
    enable = true;
    execWheelOnly = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      alsa-lib
      glib
      expat
      libxcb
      libxrandr
      libxfixes
      libxext
      pango
      cairo
      udev
      stdenv.cc.cc
      zlib
      nspr
      atk
    ];
  };
}
