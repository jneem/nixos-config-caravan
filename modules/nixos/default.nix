# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  cosmic = import ./cosmic.nix;
  greetd-niri-autologin = import ./greetd-niri-autologin.nix;
  niepce = import ./niepce.nix;
  scanner = import ./scanner.nix;
}
