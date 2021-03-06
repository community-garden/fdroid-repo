{ config, pkgs, ... }:
{
  imports = [
    ./fdroid-repo.nix
  ];

  services.fdroid-repo = {
    enable = true;
    repo_url = "https://fdroid.pergola.gra.one";
    repo_name = "Pergola";
    repo_description = ''
      This F-Droid repository provides
      the Android client of the
      Pergola community garden app.
    '';
  };

  services.nginx = {
    enable = true;
    enableReload = true;
    virtualHosts."fdroid.pergola.gra.one" = {
      locations."/fdroid" = {
        root = "/etc/nixos";
      };
    };
  };

  fileSystems = {"/".device = "/dev/null";};
  boot.loader.grub.enable = false;
}
