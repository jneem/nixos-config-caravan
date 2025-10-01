{ config, lib, pkgs, ... }:
{
  services.navidrome = {
    enable = true;
    openFirewall = true;
    settings = {
      MusicFolder = "/mnt/storage/Music";
      # TODO: behind a proxy?
      Address = "0.0.0.0";
    };
  };
}
