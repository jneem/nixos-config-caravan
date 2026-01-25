{ pkgs, ... }:
{
  systemd.user.services.radicle-node = {
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    description = "Radicle node";
    serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.radicle-node}/bin/radicle-node'';
    };
  };
}
