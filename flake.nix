{
  description = "NixOS configuration (flake‑based)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      # ───── formatter for `nix fmt` ────────────────────────────
      formatter.${system} = pkgs.nixpkgs-fmt;

      # ───── NixOS host definitions ─────────────────────────────
      nixosConfigurations = {
        apollo = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit self; };

          modules = [
            ./machines/apollo.nix
            nixos-hardware.nixosModules.framework-13-7040-amd

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.erich = { };
            }

            # --- host‑specific settings declared inline ----------
            { networking.hostName = "apollo"; }
          ];
        };
      };
    };
}
