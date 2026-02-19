{ pkgs, ... }:
{
  systemd.user.services.obex = {
    Unit.Description = "Bluetooth OBEX service";
    Service = {
      Type = "dbus";
      BusName = "org.bluez.obex";
      ExecStart = "${pkgs.bluez}/libexec/bluetooth/obexd --root=./Downloads --auto-accept --symlinks";
    };
    Install = {
      Alias = "dbus-org.bluez.obex.service";
    };
  };
}
