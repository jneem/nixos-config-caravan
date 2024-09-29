{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../common.nix
    ];

  boot = {
    initrd.systemd.enable = true;
    loader.systemd-boot.enable = true;
    kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;

    kernelParams = [
      "earlycon"
      "consoleblank=0"
      "console=tty1" # HDMI
      "console=ttyS2,1500000"
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
      "cgroup_enable=memory"
    ];
  };

  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    deviceTree = {
      enable = true;
      name = "rockchip/rk3588-friendlyelec-cm3588-nas.dtb";
    };
  };

  networking.hostName = "purple"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Bangkok";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    helix
    vim
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.domain = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.workstation = true;
  services.avahi.nssmdns4 = true;

  system.stateVersion = "24.11";

  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3Hjr4Dv+5hKLBzAxO83oiNHA0ZmaG0/LINPVOKs9+4"
      ];
    };
  };
}

