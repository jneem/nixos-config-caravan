{
pkgs,
...
}:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs31-pgtk;
    extraPackages = epkgs: [
      epkgs.company
      epkgs.eglot
      epkgs.haskell-mode
      epkgs.marginalia
      epkgs.meow
      epkgs.nickel-mode
      epkgs.nix-mode
      epkgs.nixfmt
      epkgs.rust-mode
      epkgs.orderless
      epkgs.org
      epkgs.projectile
      epkgs.vertico
    ];
  };
}
