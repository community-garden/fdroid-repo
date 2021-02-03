{
  description = "F-Droid Repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
  };

  outputs = { self, nixpkgs }:
  {
    inherit nixpkgs;

    legacyPackages.x86_64-linux = rec {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      fdroid-repo-update = import ./fdroid-repo-update.nix { inherit pkgs; };
    };

    nixosConfigurations = {
      fdroid-repo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
