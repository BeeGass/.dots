{ pkgs, ... }:

{
programs.kitty = {
    enable = true;
    shellIntegration = {
      enableZshIntegration = true;
    };
    theme = "GitHub Dark Dimmed";
    font = {
	name = "Google Sans Mono";
	size = 10;
    };
  };
}
