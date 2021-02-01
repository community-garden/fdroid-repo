{ config, pkgs, ... }:
{
  services.nginx = {
    enable = true;
    virtualHosts."fdroid2.pergola.gra.one" = {
      root = "/etc/nixos/fdroid/archive";
    };
  };

  fileSystems = {"/".device = "/dev/null";};
  boot.loader.grub.enable = false;
}
