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
	description = "Username for the main user.";
    };
};
config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
	isNormalUser = true;
	initialPassword = "12345";
	description = "Main User";
	shell = pkgs.zsh;
	extraGroups = [ "networkmanager" "wheel" ];
	packages = with pkgs; [
	    firefox
	];
	};
	programs.zsh.enable = true;
    };
}
