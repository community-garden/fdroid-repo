{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.fdroid-repo;
in
{
  options.services.fdroid-repo = {
    enable = mkEnableOption ''
      A systemd unit for updating the fdroid-repo.
      It's a oneshot run at startup.
      When you added apk-files, reload the service.
      In future we might add support for a watch on fdroid/repo.
    '';
    repo_url = mkOption {
      type = types.str;
      default = "https://example.com";
    };
    repo_name = mkOption {
      type = types.str;
      default = "Selfhosted F-Droid Repository";
    };
    repo_description = mkOption {
      type = types.str;
      default = ''
        This F-Droid Repository is
        build and served by NIXOS
        using the module developed at
        https://github.com/community-garden/fdroid-repo
      '';
    };
    package = mkOption {
      type = types.package;
      default = import ./fdroid-repo-update.nix { inherit pkgs config; };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ config.services.fdroid-repo.package ];

    systemd.services.fdroid-repo-update = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      serviceConfig.ExecStart = "${config.services.fdroid-repo.package}/bin/fdroid-repo-update";
    };
  };
}
