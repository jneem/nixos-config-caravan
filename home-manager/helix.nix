{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "onedark";
      editor =  {
        auto-pairs = false;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        end-of-line-diagnostics = "hint";
        file-picker.hidden = false;
        search.smart-case = false;
        smart-tab.enable = false;
      };
      keys = {
        normal = {
          C-j = "half_page_down";
          C-k = "half_page_up";
          C-d = ":reset-diff-change";
        };
      };
    };
    languages = {
      language = [
        {
          name = "rust";
          file-types = [ "rs" ];
          roots = [".lsproot"];
          indent = { tab-width = 4; unit = "    "; };
        }
        {
          name = "nix";
          file-types = [ "nix" ];
          indent = { tab-width = 2; unit = "  "; };
        }
        {
          name = "nickel";
          file-types = [ "ncl" ];
          auto-format = true;
        }
        {
          name = "typst";
          file-types = [ "typ" ];
          language-servers = [ "tinymist" ];
        }
      ];

      language-server.rust-analyzer.config = {
        checkOnSave = true;
        check = {
          command = "clippy";
        };
        rust = {
          analyzerTargetDir = true;
        };
        files.watcher = "server";
      };

      language-server.tinymist = {
        command = "tinymist";
        config = {
          preview.background.enabled = true;
        };
      };
    };
  };
}
