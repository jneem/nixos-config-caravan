 {
  programs.alacritty = {
    enable = true;
    settings = {
      window.decorations = "none";
      font = {
        normal = {
          family = "Inconsolata";
          style = "Regular";
        };

        bold = {
          family = "Inconsolata";
          style = "Bold";
        };

        italic = {
          family = "Inconsolata";
          style = "Italic";
        };

        bold_italic = {
          family = "Inconsolata";
          style = "Bold Italic";
        };

        size = 16;
      };
    };
  };
}
