{ config, lib, pkgs, ... }:
let keys = import ../ssh-keys.nix; in
{
  imports =
    [
      ./hardware-configuration.nix
      ./nas.nix
      ./grafana.nix
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
    htop
    vim
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.domain = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.workstation = true;
  services.avahi.nssmdns4 = true;

  # TODO: figure out authentication
  services.victoriametrics = {
    enable = true;
    retentionPeriod = "100y";

    prometheusConfig = {
      scrape_configs = [
        {
          job_name = "node-exporter";
          scrape_interval = "15s";
          static_configs = [
            { targets = ["localhost:9100"]; labels.type = "node"; }
          ];
        }
      ];
    };
  };

  services.prometheus.exporters.node.enable = true;

  services.victorialogs = {
    enable = true;
  };

  services.journald.upload = {
    enable = true;
    settings.Upload.URL = "http://localhost:9428/insert/journald";
  };

  system.stateVersion = "24.11";

  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        keys.user."jneeman@zeus"
        keys.user."jneeman@caravan"
      ];
    };
  };
}

