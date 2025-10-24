{ config, ... }:
{
  hardware.deviceTree.overlays = [
    { name = "pwm_fan"; dtsFile = ./pwm_fan.dts; }
  ];
}
