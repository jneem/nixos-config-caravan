{
  config,
  inputs,
  outputs,
  pkgs,
  ...
}:
let
  makeCommand = command: {
    command = [command];
  };
  makeCommandArgs = command: {
    command = command;
  };
in
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  programs.niri = {
    enable = true;
    settings = {
      environment = {
        NIXOS_OZONE_WL = "1";
        GDK_BACKEND = "wayland";
        QT_QPA_PLATFORM = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        SDL_VIDEODRIVER = "wayland";
      };
      spawn-at-startup = [
        #(makeCommand "${outputs.packages.${pkgs.system}.cosmic-ext-alt}/bin/cosmic-ext-alternative-startup")
        #(makeCommand "${pkgs.cosmic-panel}/bin/cosmic-panel")
        (makeCommand "${pkgs.waybar}/bin/waybar")
        (makeCommand "${pkgs.mako}/bin/mako")
        (makeCommandArgs ["${pkgs.networkmanagerapplet}/bin/nm-applet" "--indicator"])
      ];

      input = {
        focus-follows-mouse.enable = true;
        warp-mouse-to-focus.enable = true;

        touchpad = {
          dwt = true;
        };

        tablet = {
          map-to-output = "DP-3";
        };
      };

      # TODO: this should be factored into a machine-dependent config
      outputs = {
        "eDP-1" = {
          scale = 1.0;
        };
        "DP-3" = {
          scale = 1.0;
          position = { x = 0; y = 0; };
          focus-at-startup = true;
        };
        "DP-2" = {
          scale = 1.0;
          position = { x = 3840; y = 0; };
        };
      };

      cursor = {
        size = 96;
        theme = "Curlossal";
        hide-after-inactive-ms = 1000;
        hide-when-typing = true;
      };

      layout = {
        preset-column-widths = [
          {proportion = 1.0 / 3.0;}
          {proportion = 1.0 / 2.0;}
          {proportion = 1.0;}
        ];
        default-column-width = {proportion = 1.0 / 2.0;};

        gaps = 4;
      };

      binds = with config.lib.niri.actions; {
        "Mod+Return".action.spawn = "alacritty";
        "Mod+D".action.spawn = "${pkgs.fuzzel}/bin/fuzzel";

        "Mod+Q".action = close-window;
        "Mod+R".action = switch-preset-column-width;

        "Mod+H".action = focus-column-or-monitor-left;
        "Mod+L".action = focus-column-or-monitor-right;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;

        "Mod+Ctrl+J".action = focus-workspace-down;
        "Mod+Ctrl+K".action = focus-workspace-up;

        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+J".action = move-window-to-workspace-down;
        "Mod+Shift+K".action = move-window-to-workspace-up;

        "Mod+Ctrl+H".action = focus-monitor-left;
        "Mod+Ctrl+L".action = focus-monitor-right;
        "Mod+Ctrl+Shift+H".action = move-window-to-monitor-left;
        "Mod+Ctrl+Shift+L".action = move-window-to-monitor-right;

        XF86AudioRaiseVolume.action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
        XF86AudioLowerVolume.action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
        XF86AudioMute.action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
        XF86AudioMute.allow-when-locked = true;
      };
    };
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      font-size = 24;
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
    ];
    timeouts = [
      { timeout = 600; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      { timeout = 601; command = "${pkgs.niri}/bin/niri msg action power-off-monitors"; }
    ];
  };

  services.blueman-applet.enable = true;
}
