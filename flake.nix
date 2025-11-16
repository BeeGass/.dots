{
  description = "Homelab NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, sops-nix, impermanence, ... }@inputs:
    let
      system = "x86_64-linux";

      # Import helper functions from lib
      homelabLib = import ./config/lib { inherit (nixpkgs) lib; };

      # Common module arguments passed to all configurations
      specialArgs = {
        inherit inputs homelabLib;
      };

      # Helper to create NixOS system configurations
      mkHost = { hostname, system ? "x86_64-linux", modules ? [] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs;
          modules = [
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            {
              home-manager = {
                useGlobalPkgs = true;
                extraSpecialArgs = specialArgs;
              };
            }
          ] ++ modules;
        };
    in
    {
      # NixOS system configurations
      nixosConfigurations = {
        # ML Workstations
        tensor = mkHost {
          hostname = "tensor";
        };

        manifold = mkHost {
          hostname = "manifold";
        };

        # Laptop
        laptop = mkHost {
          hostname = "laptop";
        };

        # Raspberry Pi homelab nodes
        jacobian = mkHost {
          hostname = "jacobian";
          system = "aarch64-linux";
        };

        hessian = mkHost {
          hostname = "hessian";
          system = "aarch64-linux";
        };
      };

      # Expose modules for reuse in other flakes
      nixosModules = {
        # Services
        tailscale = import ./config/nixos/modules/services/tailscale.nix;
        monitoring = import ./config/nixos/modules/services/monitoring.nix;
        containerRuntime = import ./config/nixos/modules/services/container-runtime.nix;

        # Hardware
        nvidiaDrivers = import ./config/nixos/modules/hardware/nvidia-drivers.nix;
        performanceTuning = import ./config/nixos/modules/hardware/performance-tuning.nix;
        powerManagement = import ./config/nixos/modules/hardware/power-management.nix;

        # Security
        sshServer = import ./config/nixos/modules/security/ssh-server.nix;
        secretsManagement = import ./config/nixos/modules/security/secrets-management.nix;

        # Storage
        btrfsSnapshots = import ./config/nixos/modules/storage/btrfs-snapshots.nix;
        systemUpdates = import ./config/nixos/modules/storage/system-updates.nix;

        # Profiles
        base = import ./config/nixos/profiles/base.nix;
        workstation = import ./config/nixos/profiles/workstation.nix;
        mlWorkstation = import ./config/nixos/profiles/ml-workstation.nix;
        raspberryPi = import ./config/nixos/profiles/raspberry-pi.nix;
      };

      # Development shells
      devShells.${system} = {
        default = import ./templates/dev-shells/python-general.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        ml-jax = import ./templates/dev-shells/ml-jax.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        ml-pytorch = import ./templates/dev-shells/ml-pytorch.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };
      };
    };
}
