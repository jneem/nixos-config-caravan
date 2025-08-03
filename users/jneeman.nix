{ pkgs, ... }:
{
  users.users.jneeman = {
    initialPassword = "correcthorsebatterystaple";
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "docker" "podman" "networkmanager" "wheel" "video" "scanner" "lp" "libvirtd" "dialout" "disk" "audio"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3Hjr4Dv+5hKLBzAxO83oiNHA0ZmaG0/LINPVOKs9+4"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpAveBRfqrg7a41+qdOxw5WT3CbEi7dwlgKObSM85YP jneeman@zeus"
    ];
  };

  programs.fish.enable = true;
}
