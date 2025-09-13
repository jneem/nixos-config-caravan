{ config, ... }:
{
  services.nfs.server = {
    enable = true;
    exports = ''
    /mnt/storage zeus.lan(insecure,rw,sync,no_subtree_check)
    /mnt/storage 192.168.8.0/24(insecure,sync,no_subtree_check)
    '';
  };
  networking.firewall.allowedTCPPorts = [ 2049 ];
}
