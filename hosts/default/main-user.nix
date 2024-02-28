{ lib, config, pkgs, ... }:

let
  cfg = config.main-user;
in
{
options.main-user = {
    enable = lib.mkEnableOption "Whether to enable the main user module";
    userName = lib.mkOption {
	type = lib.types.str;
	default = "mainuser";
	description = "Username for the main useer.";
    };
    description = lib.mkOption {
	type = lib.types.str;
	default = "Username for the main user.";
	description = "Desciption for the main user.";
    };
    initialPassword = lib.mkOption {
	type = lib.types.str;
	default = "12345";
	description = "Initial password for the main user";
    };
    packages = lib.mkOption {
	type = lib.types.listOf lib.types.package;
	default = with pkgs; [];
	description = "List of packages for the main user.";
    };
};
config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
	isNormalUser = true;
	initialPassword = cfg.initialPassword;
	description = cfg.description;
	extraGroups = [ "networkmanager" "wheel" ];
	packages = cfg.packages;
	shell = pkgs.zsh;
	programs.zsh.enable = true;
	};
    };
}
