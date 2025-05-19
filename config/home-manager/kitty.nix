{ pkgs, lib, ... }:

{
programs.kitty = {
    enable = true;
    shellIntegration = {
      enableZshIntegration = true;
    };
    themeFile = lib.mkDefault "Github Dark Dimmed";
    # theme = lib.mkDefault "GitHub Dark Dimmed";
    font = {
	name = lib.mkDefault "Google Sans Mono monospacified for Google Sans Mono";
	size = lib.mkDefault 10;
    };
  };
}
