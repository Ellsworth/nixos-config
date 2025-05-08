{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    }
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    inputs@{ self, nixpkgs, home-manager, nixos-hardware, ... }:
    {
      nixosConfigurations = {
        hostname = nixpkgs.lib.artemis {
          system = "x86_64-linux";
          modules = [
            ./machines/artemis.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };
        hostname = nixpkgs.lib.apollo {
          system = "x86_64-linux";
          modules = [
            ./machines/apollo.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
            nixos-hardware.nixosModules.dell-xps-13-9380
          ];
        };
      };
    };
}
