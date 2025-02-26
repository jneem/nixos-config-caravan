{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.jneeman = {
      extensions.packages = with pkgs.inputs.firefox-addons; [
        ublock-origin
        bitwarden
        multi-account-containers
      ];

      containersForce = true;
      containers = {
        work = {
          color = "orange";
          icon = "briefcase";
          id = 1;
        };
      };

      search = {
        default = "DuckDuckGo";
        force = true;
        engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "/pkg" ];
          };

          "Google".metaData.alias = "/g";

          "crates.io" = {
            urls = [{
              template = "https://crates.io/search?q={searchTerms}";
            }];
            definedAliases = [ "/crate" ];
          };

          "docs.rs" = {
            urls = [{
              template = "https://docs.rs/releases/search?query={searchTerms}";
            }];
            definedAliases = [ "/doc" ];
          };
        };
      };
    };
  };


}
