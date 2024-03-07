{ config, lib, pkgs, ... }:

let 
  mod = "Mod4";
in {
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;

      fonts = ["DejaVu Sans Mono, FontAwesome 6"];

      keybindings = lib.mkOptionDefault {
        "${mod}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";
        "${mod}+x" = "exec sh -c '${pkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
        "${mod}+Shift+x" = "exec sh -c '${pkgs.i3lock}/bin/i3lock -c 222222 & sleep 5 && xset dpms force of'";
	
	# Move the selected window to the specified workspace
	"${mod}+1" = "workspace 1";
	"${mod}+2" = "workspace 2";
	"${mod}+3" = "workspace 3";
	"${mod}+4" = "workspace 4";
	"${mod}+5" = "workspace 5";
	"${mod}+6" = "workspace 6";
	"${mod}+7" = "workspace 7";
	"${mod}+8" = "workspace 8";
	"${mod}+9" = "workspace 9";
	"${mod}+0" = "workspace 10";

        # Move
	"${mod}+Left" = "move left";
	"${mod}+Right" = "move right";
	"${mod}+Up" = "move up";
	"${mod}+Down" = "move down";

        # My multi monitor setup
        "${mod}+m" = "move workspace to output DP-2";
        "${mod}+Shift+m" = "move workspace to output DP-5";

	# Open Rofi application launcher
	"${mod}+space" = "exec rofi -show drun";
      };
    };
  };
}
