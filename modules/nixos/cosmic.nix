{
  inputs,
  pkgs,
  ...
}: {
  environment = {
    variables.NIXOS_OZONE_WL = "1";
    sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
    sessionVariables.XDG_SESSION_TYPE = "wayland";
    systemPackages = [
      pkgs.cosmic-ext-applet-minimon
    ];
  };

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "jneeman";
  };
}
