{ config, pkgs, inputs, ... }:

{
  fonts = {
    fontconfig.enable = true;
  };

  home.packages = with pkgs; [
    dejavu_fonts
    inconsolata
    nerd-fonts.inconsolata
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    noto-fonts-extra
    font-awesome
  ];
}
