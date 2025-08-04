# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    # Modules from modules/nixos
    # outputs.nixosModules.common
    # outputs.nixosModules.cosmic-with-niri
    outputs.nixosModules.greetd-niri-autologin

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    # inputs.nixos-hardware.nixosModules.framework-16-7040-amd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    # inputs.nixos-cosmic.nixosModules.default

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ../common.nix

    ../../users/jneeman.nix
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome ];
    config = {
      common = {
        default = "gtk";
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
      };
    };
  };

  time.timeZone="America/Chicago";
  # virtualisation.docker.enable = true;

  #boot.kernelPackages = pkgs.linuxPackages_6_14;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "zeus";
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

  # services.displayManager.cosmic-greeter.enable = true;
  # services.desktopManager.cosmic.enable = true;
  services.fwupd.enable = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "jneeman";
  };
  #programs.sway.enable = true;
  programs.geary.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-unikey fcitx5-gtk ];
      fcitx5.waylandFrontend = true;
    };
  };

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    bat
    linuxPackages_6_14.perf
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
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
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
    wally-cli
    wget
    wireguard-tools
    wl-clipboard
    xh
    zed-editor

    # clinfo
    # rocmPackages.clr.icd
    # rocmPackages.hipcc
    # rocmPackages.clr
    # rocmPackages.rocminfo
    # rocmPackages.rocm-smi

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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
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

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };
  virtualisation.containers = {
    enable = true;
    registries.insecure = ["gitlab.contabo.intra:5050"];
  };

  # networking.networkmanager.insertNameservers = ["1.1.1.1"];
  # networking.wireguard.interfaces = {
  #   wgtest = {
  #     ips = [ "192.168.2.2/32" ];
  #     listenPort = 51872;
  #     privateKeyFile = "/home/jneeman/wireguard-keys/caravan/private";
  #     peers = [
  #       {
  #         publicKey = "/6mwmfHSwTs90LFH6kMZxcKKf7YEs06oJdRAbhstRz8=";
  #         allowedIPs = [ "192.168.2.0/24" ];
  #         #allowedIPs = [ "0.0.0.0/0" ];
  #         endpoint = "49.13.72.117:51820";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };

  systemd.services.configure-webcam = {
    description = "Set webcam resolution and zoom at boot";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.v4l-utils}/bin/v4l2-ctl \
          --device=/dev/video0 \
          --set-fmt-video=width=1280,height=720,pixelformat=YUYV
        ${pkgs.v4l-utils}/bin/v4l2-ctl \
          --device=/dev/video0 \
          --set-ctrl=zoom_absolute=250
      '';
    };
  };
}
