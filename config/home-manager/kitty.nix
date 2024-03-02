{ pkgs, ... }:

{
programs.kitty = {
    enable = true;
    shellIntegration = {
      enableZshIntegration = true;
    };
    theme = "GitHub Dark Dimmed";
    font = {
	name = "Fira Code";
	size = 10;
    };
  };
}
