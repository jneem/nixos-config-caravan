{ config, lib, pkgs, ... }:
{
  services.navidrome = {
    enable = true;
    openFirewall = true;
    settings = {
      MusicFolder = "/mnt/storage/Music";
      Address = "127.0.0.1";
      PID.Album = "album,composer,albumartistid";
    };
  };
  services.caddy = {
      enable = true;
      virtualHosts."http://music.treeman" = {
          # TODO: make this definitionally the same as the wireguard address
          listenAddresses = [ "10.67.67.3" ];
          extraConfig = ''
              reverse_proxy http://localhost:4533
          '';
      };
  };
}
