{ pkgs, ... }:
let keys = import ../nixos/ssh-keys.nix; in
{
  users.users.jneeman = {
    initialPassword = "correcthorsebatterystaple";
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "docker" "podman" "networkmanager" "wheel" "video" "scanner" "lp" "libvirtd" "dialout" "disk" "audio" "scanner"];
    openssh.authorizedKeys.keys = [
      keys.user."jneeman@zeus"
      keys.user."jneeman@caravan"
    ];
  };

  programs.fish.enable = true;
}
