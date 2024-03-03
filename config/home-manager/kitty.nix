{ pkgs, ... }:

{
programs.kitty = {
    enable = true;
    shellIntegration = {
      enableZshIntegration = true;
    };
    theme = "GitHub Dark Dimmed";
    font = {
	name = "Source Code Pro";
	size = 10;
    };
  };
}
