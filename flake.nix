{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      nixosSystem = { name, configuration }: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          configuration
          inputs.home-manager.nixosModules.home-manager
        ];
      };
    in {
      nixosConfigurations = {
        default = nixosSystem {
          name = "default";
          configuration = ./hosts/default/configuration.nix;
        };
        desktop = nixosSystem {
          name = "desktop";
          configuration = ./hosts/desktop/configuration.nix;
        };
        laptop = nixosSystem {
          name = "laptop";
          configuration = ./hosts/laptop/configuration.nix;
        };
        macbook = nixosSystem {
          name = "macbook";
          configuration = ./hosts/macbook/configuration.nix;
        };
        home-server = nixosSystem {
          name = "home-server";
          configuration = ./hosts/home-server/configuration.nix;
        };
        remote-server = nixosSystem {
          name = "remote-server";
          configuration = ./hosts/remote-server/configuration.nix;
        };
        vm = nixosSystem {
          name = "vm";
          configuration = ./hosts/vm/configuration.nix;
        };
	#Add more hosts as needed
      };
    };
}
