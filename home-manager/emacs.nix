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
      epkgs.counsel
      epkgs.eglot
      epkgs.haskell-mode
      epkgs.ivy
      epkgs.meow
      epkgs.nix-mode
      epkgs.nixfmt
      epkgs.org
    ];
  };
}
