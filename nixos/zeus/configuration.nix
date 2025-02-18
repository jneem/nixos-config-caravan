# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    # Modules from modules/nixos
    # outputs.nixosModules.common

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    inputs.nixos-cosmic.nixosModules.default

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ../common.nix
  ];

  time.timeZone="Asia/Bangkok";
  virtualisation.docker.enable = true;

  # Recent kernel fixed issues with power-off
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "caravan";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [42000 42001];
  networking.firewall.allowedUDPPorts = [42000 42001];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.fwupd.enable = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  programs.sway.enable = true;
  programs.geary.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  i18n = {
    defaultLocale = "en_US.utf8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-unikey fcitx5-gtk ];
      fcitx5.waylandFrontend = true;
    };
  };

  environment.systemPackages = with pkgs; [
    bat
    #blender
    inputs.nixpkgs-stable.legacyPackages.${system}.blender
    cntr
    darktable
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
    jujutsu
    neovim
    nil
    openscad-unstable
    orca-slicer
    p7zip
    ripgrep
    unzip
    vim
    wally-cli
    wget
    wl-clipboard
    xh
    zed-editor

    clinfo
    rocmPackages.clr.icd
    rocmPackages.hipcc
    rocmPackages.clr
    rocmPackages.rocminfo
    rocmPackages.rocm-smi

    # ((llama-cpp.overrideAttrs (final: prev: {
    #   cmakeFlags = (prev.cmakeFlags ++ [ "-DGGML_HIP=ON" ]);
    # })).override { rocmSupport =  true; })
  ];

  # systemd.tmpfiles.rules = [
  #   "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  #   "L+ /opt/rocm/llvm - - - - ${pkgs.rocmPackages.llvm.llvm}"
  # ];

    
  programs.dconf.enable = true;
  programs.fish.enable = true;

  security.sudo = {
    enable = true;
    execWheelOnly = true;
  };

  hardware.amdgpu = {
    opencl.enable = true;
    amdvlk.enable = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      alsa-lib
      glib
      expat
      xorg.libxcb
      xorg.libXrandr
      xorg.libXfixes
      xorg.libXext
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
