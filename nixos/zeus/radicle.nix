{ ... }:

{
  systemd.user.services.radicle-node = {
    enable = true;
    unitConfig.ConditionUser = "jneeman";
  };
}
