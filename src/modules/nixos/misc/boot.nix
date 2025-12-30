{ ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-ffffa5d7-c2ae-46b1-9c5a-8a1cfa3260b9".device = "/dev/disk/by-uuid/ffffa5d7-c2ae-46b1-9c5a-8a1cfa3260b9";
}
