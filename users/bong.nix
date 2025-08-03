{ pkgs, ... }:

{
  users.users.bong = {
    isNormalUser = true;
    description = "Mai Tran-Neeman";
    shell = pkgs.bash;
    extraGroups = [ "video" "scanner" "lp" ];

  };
}
