{
  config,
  pkgs,
  lib,
  ...
}:
let
  asciidoc-ts = pkgs.fetchFromGitHub { owner = "cathaysia"; repo = "tree-sitter-asciidoc"; rev = "5b6ccea9953b939959f447f7bfea699ae6968a99"; hash = "sha256-mhBSe5umX2asVUwFWHvuVHQC33wOEy6s14dZWn3wAbQ="; };
in

{
  # Whenever asciidoc-ts is updated, you need to manually remove the old object files, as hx won't rebuild it due to Nix's epoch timestamps.
  # $ rm ~/.config/helix/runtime/grammars/asciidoc*.so
  # It might be worth switching to git sources that hx can fetch/manage instead of path sources under the control of the flake for this reason.
  home.activation.hx-grammar-build = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${pkgs.stdenv.cc}/bin:${config.programs.helix.package}/bin:${config.programs.git.package}/bin:$PATH"
    run --quiet hx --grammar fetch # Only necessary for git URL based sources
    run --quiet hx --grammar build
  '';
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
      grammar = [
        {
          name = "asciidoc";
          source.path = "${asciidoc-ts}/tree-sitter-asciidoc";
        }
        {
          name = "asciidoc_inline";
          source.path = "${asciidoc-ts}/tree-sitter-asciidoc_inline";
        }
      ];

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
          name = "asciidoc";
          language-id = "asciidoc";
          scope = "source.adoc";
          injection-regex = "adoc";
          file-types = [ "adoc" ];
          comment-tokens = [ "//" ];
          block-comment-tokens = [{
            start = "////";
            end = "////";
          }];
          grammar = "asciidoc";
        }
        {
          name = "asciidoc_inline";
          language-id = "asciidoc_inline";
          scope = "source.asciidoc_inline";
          injection-regex = "asciidoc_inline";
          file-types = [];
          grammar = "asciidoc_inline";
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
    };
  };

  xdg.configFile."helix/runtime/queries/asciidoc".source = "${asciidoc-ts}/queries/asciidoc";
  xdg.configFile."helix/runtime/queries/asciidoc_inline".source = "${asciidoc-ts}/queries/asciidoc_inline";
}
