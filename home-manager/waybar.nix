  {pkgs, ...}:
  {
  programs.waybar = {
    enable = true;
    style = ./waybar-style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 32;
        modules-left = [ "niri/workspaces" ];
        modules-right = [ "disk" "memory" "cpu" "network" "pulseaudio" "battery" "backlight" "clock" "tray" "idle_inhibitor" ];
        battery = {
          format = "{icon} {capacity}%";
          format-good = "{icon} {capacity}%";
          format-full = " {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          interval = 30;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            "activated" = "";
            "deactivated" = "";
          };
        };
        backlight = {
          device = "intel_backlight";
          format = " {percent}%";
          interval = 60;
        };
        network = {
          format = "{bandwidthUpBytes:>}  {bandwidthDownBytes:>} ";
          interval = 1;
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = "()";
          interval = 60;

          format-icons = {
            default = [ "" ];
          };
        };

        clock = {
          interval = 10;
          format = "{:%H:%M %Y-%m-%d (%a)}";
        };

        cpu = {
          interval = 1;
          format = "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}{icon8}{icon9}{icon10}{icon11}{icon12}{icon13}{icon14}{icon15}";
          format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
        };

        disk = {
          interval = 60;
          format = " {free}";
        };

        memory = {
          format = " {percentage}%";
        };
      };
    };
  };
}

