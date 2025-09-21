{ pkgs, ... }:
{
  hardware.printers.ensurePrinters = [{
    location = "South Study";
    deviceUri = "ipp://niepce/ipp/print";
    description = "Epson XP-15000";
    name = "Niepce";
    model = "epson-inkjet-printer-escpr2/Epson-XP-15000_Series-epson-escpr2-en.ppd";
  }];
}
