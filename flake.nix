{
  description = "F-Droid Repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
  };

  outputs = { self, nixpkgs }:
  {
    inherit nixpkgs;

    legacyPackages.x86_64-linux = {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
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
