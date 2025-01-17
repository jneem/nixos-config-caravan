# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./firefox.nix
    ./helix.nix
    ./fonts.nix
    ./alacritty.nix
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.flake-inputs
      outputs.overlays.modifications

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;

      packageOverrides = pkgs: {
        factorio = pkgs.factorio.override {
          username = "jneem";
          token = "f23c7049ec63cf6f930b838a0f2f70";
        };
      };
    };
  };

  home = {
    username = "jneeman";
    homeDirectory = "/home/jneeman";
    sessionVariables = {
      EDITOR = "hx";
    };

    pointerCursor = {
      package = pkgs.inputs.curlossal.default;
      name = "Curlossal";
      size = 96;
      gtk.enable = true;
      x11.enable = true;
    };

    packages = with pkgs; [
      age
      bitwarden-cli
      chromium
      digikam
      eog
      exiftool
      gimp
      inkscape
      krita
      factorio
      gdb
      gh
      grim
      mpv
      pari
      pavucontrol
      picocom
      rclone
      slurp
      slack
      steam
      vlc
      wally-cli
      wl-clipboard
      zathura
    ];
  };

  # This is needed for our cursor theme settings to take effect in gtk apps.
  gtk.enable = true;

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    ignores = [ ".envrc" ".direnv" ];
    lfs.enable = true;
    userName = "Joe Neeman";
    userEmail = "joeneeman@gmail.com";
    includes = [
      {
        path = "~/tweag/.gitconfig";
        condition = "gitdir:~/tweag/";
      }
    ];
    extraConfig = {
      push.default = "upstream";
    };
  };
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.lazygit.enable = true;

  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting
    '';
    shellAbbrs = {
      llw = "ll -snew";
    };
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    
    settings = {
      aws.disabled = true;
      gcloud.disabled = true;
      package.disabled = true;
      nix_shell.format = "via [❄️ $name]($style) ";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  home.file.tweag-gitconfig = {
    target = "tweag/.gitconfig";
    text = ''
    [user]
    email = joe.neeman@tweag.io
    '';
  };

  home.file.cargo-config = {
    target = ".cargo/config.toml";
    text = ''
    [profile.rust-analyzer]
    inherits = "dev"
    '';
  };


  # Nicely reload system units when changing configs
  #systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
