{ pkgs }:
{
  home = {
    username = "bong";
    homeDirectory = "/home/bong";
    stateVersion = "23.05";

    packages = with pkgs; [
      gimp
      inkscape
      libreoffice
      tuxtype
      vlc
    ];
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = {
        enableGnomeExtensions = true;
      };
    };
  };
}

