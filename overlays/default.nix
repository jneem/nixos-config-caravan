# This file defines overlays
{inputs, ...}: {

  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}'
  flake-inputs = final: _: {
    inputs = builtins.mapAttrs (
      _: flake: (flake.packages or {}).${final.system} or {}
    )
    inputs;
  };

  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # Temporary hack for broken package, see
    # https://github.com/NixOS/nixpkgs/issues/437429
    osm-gps-map = prev.osm-gps-map.overrideAttrs (o: {
      nativeBuildInputs = (o.nativeBuildInputs or []) ++ [final.autoreconfHook final.gtk-doc];
    });
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };
}
