{ inputs, config, ... }:
let wgKeys = import ../wg-keys.nix; in
{
  age.secrets.wg-key = {
    file = "${inputs.self.outPath}/nixos/secrets/wg-key-zeus.age";
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];

  systemd.network = {
    enable = true;
    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [
        "10.67.67.2/32"
      ];
    };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = 51820;
        PrivateKeyFile = config.age.secrets.wg-key.path;
        RouteTable = "main";
      };

      wireguardPeers = [
        {
          PublicKey = wgKeys.router;
          AllowedIPs = [ "10.67.67.0/24" ];
          Endpoint = "192.168.8.1:51820";
          PersistentKeepalive = 25;
        }
      ];
    };
  };
}
