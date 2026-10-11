let
  keys = import ../ssh-keys.nix;
in
{
  "restic-env.age".publicKeys = [ keys.user."jneeman@caravan" keys.user."jneeman@zeus" keys.host.caravan keys.host.zeus keys.host.purple ];
  "restic-password.age".publicKeys = [ keys.user."jneeman@caravan" keys.user."jneeman@zeus" keys.host.caravan keys.host.zeus keys.host.purple ];
  "wg-key-kawaii.age".publicKeys = [ keys.user."jneeman@caravan" keys.user."jneeman@zeus" keys.host.kawaii ];
  "wg-key-purple.age".publicKeys = [ keys.user."jneeman@caravan" keys.user."jneeman@zeus" keys.host.purple ];
  "wg-key-zeus.age".publicKeys = [ keys.user."jneeman@caravan" keys.user."jneeman@zeus" keys.host.zeus ];
}
