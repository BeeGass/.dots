{ pkgs, lib, ... }:

{
programs.kitty = {
    enable = true;
    shellIntegration = {
      enableZshIntegration = true;
    };
    theme = lib.mkDefault "GitHub Dark Dimmed";
    font = {
	name = lib.mkDefault "Google Sans Mono";
	package = lib.mkDefault (pkgs.callPackage ./fonts/google-sans-mono.nix {});
	size = lib.mkDefault 10;
    };
  };
}
