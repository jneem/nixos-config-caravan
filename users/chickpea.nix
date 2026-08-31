{ pkgs, ... }:

{
  users.users.chickpea = {
    isNormalUser = true;
    description = "Lily Tran-Neeman";
    shell = pkgs.bash;
    extraGroups = [ "video" "scanner" "lp" ];

  };
}
