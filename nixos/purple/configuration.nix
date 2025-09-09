{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../common.nix
      ../../users/jneeman.nix
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

    supportedFilesystems = [ "bcachefs" ];
  };

  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    deviceTree = {
      enable = true;
      name = "rockchip/rk3588-friendlyelec-cm3588-nas.dtb";
    };
  };

  networking.hostName = "purple";
  networking.networkmanager.enable = true;
  time.timeZone="America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    git
    helix
    vim
  ];

  # TODO: only public key access
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
      # TODO: put these ssh keys somewhere common
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3Hjr4Dv+5hKLBzAxO83oiNHA0ZmaG0/LINPVOKs9+4 jneeman@caravan"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpAveBRfqrg7a41+qdOxw5WT3CbEi7dwlgKObSM85YP jneeman@zeus"
      ];
    };
  };
}

