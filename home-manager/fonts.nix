{ config, pkgs, inputs, ... }:

{
  fonts = {
    fontconfig.enable = true;
  };

  home.packages = with pkgs; [
    dejavu_fonts
    inconsolata
    inconsolata-nerdfont
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    font-awesome
  ];
}
