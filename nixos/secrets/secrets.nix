let
  keys = import ../ssh-keys.nix;
in
{
  "restic-env.age".publicKeys = [ keys.user."jneeman@caravan" keys.user."jneeman@zeus" keys.host.caravan keys.host.zeus keys.host.purple ];
  "restic-password.age".publicKeys = [ keys.user."jneeman@caravan" keys.user."jneeman@zeus" keys.host.caravan keys.host.zeus keys.host.purple ];
}
