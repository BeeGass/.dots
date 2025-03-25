{ config, lib, pkgs, ... }:

let 
  mod = "Mod4";
  wallpaper_path = "~/.dots/assets/background.png"; #~/Pictures/background.png
in {
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = mod;

      fonts = ["Google Sans Mono monospacified for Google Sans Mono 6"];

      bars = [ ];

      gaps = {
        inner = 15;
        outer = 5;
      };

      keybindings = lib.mkOptionDefault {
        "${mod}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";
        "${mod}+x" = "exec sh -c '${pkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
        "${mod}+Shift+x" = "exec sh -c '${pkgs.i3lock}/bin/i3lock -c 222222 & sleep 5 && xset dpms force of'";
	
        # Move the selected window to the specified workspace
        "${mod}+1" = "workspace 0";
        "${mod}+2" = "workspace 1";
        "${mod}+3" = "workspace 2";
        "${mod}+4" = "workspace 3";
        "${mod}+5" = "workspace 4";
        "${mod}+6" = "workspace 5";
        "${mod}+7" = "workspace 6";
        "${mod}+8" = "workspace 7";
        "${mod}+9" = "workspace 8";
        "${mod}+0" = "workspace 9";

        # Move the focused window to the specified workspace
        "${mod}+Shift+1" = "move container to workspace 0";
        "${mod}+Shift+2" = "move container to workspace 1";
        "${mod}+Shift+3" = "move container to workspace 2";
        "${mod}+Shift+4" = "move container to workspace 3";
        "${mod}+Shift+5" = "move container to workspace 4";
        "${mod}+Shift+6" = "move container to workspace 5";
        "${mod}+Shift+7" = "move container to workspace 6";
        "${mod}+Shift+8" = "move container to workspace 7";
        "${mod}+Shift+9" = "move container to workspace 8";
        "${mod}+Shift+0" = "move container to workspace 9";

        # Application Macros
        "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "${mod}+space" = "exec rofi -show drun";

        # Move
        "${mod}+Left" = "move left";
        "${mod}+Right" = "move right";
        "${mod}+Up" = "move up";
        "${mod}+Down" = "move down";

        # My multi monitor setup
        "${mod}+m" = "move workspace to output DP-2";
        "${mod}+Shift+m" = "move workspace to output DP-5";
      };
      
      defaultWorkspace = "workspace 0";

      assigns = {
        "0" = [ { class = "^Kitty$"; } ];
        "1" = [ { class = "^Vscode$"; } ];
        "2" = [ { class = "^Google-chrome$"; } ];
        "3" = [ { class = "^Discord$"; } ];
      };

      startup = [
	      { 
          command = "systemctl --user restart polybar"; 
          always = true; 
          notification = false; 
        }
	      {
          command = "${pkgs.feh}/bin/feh --bg-scale ${wallpaper_path}";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.networkmanagerapplet}/bin/nm-applet";
          always = true;
        }

      ];

      terminal = "kitty";

      window = {
        border = 0;
        titlebar = false;
      };
    };
  };
}
