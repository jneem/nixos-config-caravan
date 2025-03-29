{ pkgs, ... }:
let
  session = {
    command = "${pkgs.niri}/bin/niri-session";
    user = "jneeman";
  };
in
{
  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = session;
      initial_session = session;
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.swaylock = {};
  services.blueman.enable = true;
}
