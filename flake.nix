{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      nixosSystem = { name }: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${name}/configuration.nix
          inputs.home-manager.nixosModules.home-manager
        ];
      };
    in {
      nixosConfigurations = {
        default = nixosSystem {
          name = "default";
        };
        desktop = nixosSystem {
          name = "desktop";
        };
        laptop = nixosSystem {
          name = "laptop";
        };
        macbook = nixosSystem {
          name = "macbook";
        };
        home-server = nixosSystem {
          name = "home-server";
        };
        remote-server = nixosSystem {
          name = "remote-server";
        };
        vm = nixosSystem {
          name = "vm";
        };
        rpi5 = nixosSystem {
          name = "rpi5";
        };
      };
    };
}
