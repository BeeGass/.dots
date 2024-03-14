{ pkgs, ... }:
 
let
  background = "#2B3C6D"; # Navy blue
  foreground = "#F7D9D0"; # Pale pink
  primary = "#4DA88E"; # Teal green
  secondary = "#FBE870"; # Bright yellow
  accent = "#8C6C5E"; # Dusty brown

  fontSize = "10";
  fontFamily = "Google Sans Mono monospacified for Google Sans Mono";
  secondFont = "Google Sans";
  thirdFont = "TerminessNerdFont";
  fourthFont = "Font Awesome 6";
in {
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3Support = true;
      pulseSupport = true;
      nlSupport = true;
    };

    script = ''
      polybar dumb &
      polybar triple-right-right &
      polybar triple-right-center &
      polybar triple-right-left &
      polybar single-center &
      polybar single-left &
    '';

    config = {
      "bar/triple-right-right" = {
        bottom = false;
        fixed-center = true;
        override-redirect = true;
        
        width = "10%";
        height = 30;

        offset-x = "89%";
        offset-y = "1%";
              
        radius-top = "-60%";
        radius-bottom = "-60%";

        background = "${background}"; 
        foreground = "${foreground}";
        padding = 1;

        locale = "en_US.UTF-8";

        modules-left = "battery";
        modules-center = "powermenu";
        modules-right = "date";

        font-0 = "${fontFamily}:size=${fontSize};3";
        font-1 = "${secondFont}:size=${fontSize};3";
      };

      "bar/triple-right-center" = {
        bottom = false;
        fixed-center = true;
        override-redirect = true;
        
        width = "10%";
        height = 30;

        offset-x = "78%";
        offset-y = "1%";
              
        radius-top = "-60%";
        radius-bottom = "-60%";

        background = "${background}"; 
        foreground = "${foreground}";
        padding = 1;

        locale = "en_US.UTF-8";

        modules-left = "pulseaudio";
        modules-center = "cpu";
        modules-right = "wlan";

        font-0 = "${fontFamily}:size=${fontSize};3";
        font-1 = "${secondFont}:size=${fontSize};3";
      };


      "bar/triple-right-left" = {
        bottom = false;
        fixed-center = true;
        override-redirect = true;
        
        width = "4%";
        height = 30;

        offset-x = "73%";
        offset-y = "1%";
              
        radius-top = "-60%";
        radius-bottom = "-60%";

        background = "${background}"; 
        foreground = "${foreground}";
        padding = 1;

        locale = "en_US.UTF-8";

        modules-left = "tray";

        font-0 = "${fontFamily}:size=${fontSize};3";
        font-1 = "${secondFont}:size=${fontSize};3";
      };

      "bar/single-center" = {
        bottom = false;
        fixed-center = true;
        override-redirect = true;
        
        width = "20%";
        height = 30;

        offset-x = "40%";
        offset-y = "1%";
              
        radius-top = "-50%";
        radius-bottom = "-50%";

        background = "${background}"; 
        foreground = "${foreground}";
        padding = 1;

        locale = "en_US.UTF-8";

        modules-center = "title";

        font-0 = "${fontFamily}:size=${fontSize};3";
        font-1 = "${secondFont}:size=${fontSize};3";
      };

      "bar/single-left" = {
        bottom = false;
        fixed-center = true;
        override-redirect = true;

        width = "10%";
        height = 30;

        offset-x = "1%";
        offset-y = "1%";
              
        radius-top = "-50%";
        radius-bottom = "-50%";

        background = "${background}"; 
        foreground = "${foreground}";
        padding = 1;

        locale = "en_US.UTF-8";

        modules-left = "i3";

        font-0 = "${thirdFont}:size=${fontSize};3";
        font-1 = "${fourthFont}:size=${fontSize};3";
      };

      "bar/dumb" = {
        override-redirect = false;
        bottom = false;
        fixed-center = true;
        wm-restack = "i3";

        width = "100%";
        height = 50; # 40

        #offset-x = "45%";
        #offset-y = "1%";

        radius-top = "-100%";
        radius-bottom = "-100%";

        # locale = "en_US.UTF-8";

        modules-center = "dumbtitle";

        # background = "#00282c34"; 
        # foreground = "#00282c34";

        background = "#ccFBE870"; 
        foreground = "#ccFBE870";

        font-0 = "${fontFamily}:size=${fontSize};3";
        font-1 = "${secondFont}:size=${fontSize};3";
      };

      "module/tray" = {
        type = "internal/tray";

        tray-background = "${background}";
        tray-foreground = "${foreground}";

        tray-position = "right";
        tray-size = "66%";
        tray-padding = 2;
        tray-max-size = 16;
        tray-scale = true;

      };

      "module/i3" = {
        type = "internal/i3";

        pin-workspaces = true;
        strip-wsnumbers = true;
        index-sort = true;
        show-urgent = true;
        enable-click = true;
        enable-scroll = false;
        wrapping-scroll = false;

        format = "<label-state> <label-mode>";
        label-mode = "%mode%";
        label-mode-padding = 2;
        label-mode-background = "${primary}";

        label-focused = "%icon%";
        label-focused-foreground = "${foreground}";
        label-focused-background = "${primary}";
        label-focused-padding = 2;

        label-unfocused = "%icon%";
        label-unfocused-foreground = "${foreground}";
        label-unfocused-background = "${background}";
        label-unfocused-padding = 2;

        label-visible = "%icon%";
        label-visible-foreground = "${foreground}";
        label-visible-background = "${background}";
        label-visible-padding = 2;

        label-urgent = "%icon%";
        label-urgent-foreground = "${foreground}";
        label-urgent-background = "#ff0000";
        label-urgent-padding = 2;

        ws-icon-0 = "0;";
        ws-icon-1 = "1;󰨞";
        ws-icon-2 = "2;";
        ws-icon-3 = "3;󰓇";
        ws-icon-4 = "4;󰙯";
        ws-icon-5 = "5;󰇏";
        ws-icon-6 = "6;󰲬";
        ws-icon-7 = "7;󰲮";
        ws-icon-8 = "8;󱂐";
        ws-icon-9 = "9;󰄕";
        ws-icon-default = "";
      };

      "module/date" = {
        type = "internal/date";

        interval = 1;
        date = "%b %d"; #"%a, %b %d"
        time = "%I:%M %p";
        format = "<label>";
        label = "%date% %time%";
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";

        format-volume = "<ramp-volume> <label-volume>";
        label-volume = "%percentage%";
        label-volume-padding = 1;
        ramp-volume-0 = "奄";
        ramp-volume-1 = "奄";
        ramp-volume-2 = "奔";
        label-muted = "婢 Muted";
        label-muted-padding = 1;
      };

      #"module/memory" = {
      #  type = "internal/memory";
      #  interval = 3;
      #  format = " <label>";
      #  label = "%percentage_used%";
      #  label-padding = 1;
      #};

      "module/cpu" = {
        type = "internal/cpu";

        interval = 2;
        label = "%percentage:3%";
        format-prefix = " ";
        label-padding = 1;

        format = "<label> <ramp-load>";
        ramp-load-0 = "▁";
        ramp-load-1 = "▂";
        ramp-load-2 = "▃";
        ramp-load-3 = "▄";
        ramp-load-4 = "▅";
        ramp-load-5 = "▆";
        ramp-load-6 = "▇";
        ramp-load-7 = "█";

        ramp-load-0-foreground = "#B6B99D";
        ramp-load-1-foreground = "#B6B99D";
        ramp-load-2-foreground = "#A0A57E";
        ramp-load-3-foreground = "#DEBC9C";
        ramp-load-4-foreground = "#DEBC9C";
        ramp-load-5-foreground = "#D1A375";
        ramp-load-6-foreground = "#D19485";
        ramp-load-7-foreground = "#C36561";
      };

      "module/wlan" = {
        type = "internal/network";
        interval = "3.0";

        format-connected = "<ramp-signal> <label-connected>";
        label-connected =
          "%essid%  ( %upspeed:9%  %downspeed:9%)";

        ramp-signal-0 = "▁";
        ramp-signal-1 = "▂";
        ramp-signal-2 = "▃";
        ramp-signal-3 = "▄";
        ramp-signal-4 = "▅";
        ramp-signal-5 = "▆";
        ramp-signal-6 = "▇";
        ramp-signal-7 = "█";
      };

      "module/battery" = {
        type = "internal/battery";

        battery = "BAT0";
        adapter = "ADP1";
        full-at = 98;
        
        format-charging = "<animation-charging> <label-charging>";

        format-discharging = "<ramp-capacity> <label-discharging>";

        format-full-prefix = " ";
        format-full-prefix-foreground = "${foreground}";

        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-foreground = "${foreground}";

        animation-charging-0 = "";
        animation-charging-1 = "";
        # animation-charging-2 = "";
        animation-charging-foreground = "${foreground}";
        animation-charging-framerate = "750";
      };

      "module/powermenu" = {
        type = "custom/menu";

        expand-right = true;
        format-spacing = 1;

        label-open = "";
        label-open-foreground = "${foreground}";
        label-close = "";
        label-close-foreground = "${foreground}";
        label-separator = "|";
        label-separator-foreground = "${foreground}";

        menu-0-0 = "Logout";
        menu-0-0-exec = "i3-msg exit";

        menu-0-1 = "Reboot";
        menu-0-1-exec = "shutdown -r now";
        
        menu-0-2 = "Shutdown";
        menu-0-2-exec = "shutdown now";
      };

      "module/title" = {
        type = "internal/xwindow";
        
        format = "<label>";
        format-foreground = "${secondary}";
        label = "%title%";
        label-maxlen = 40;
      };

      "module/dumbtitle" = {
        type = "internal/xwindow";
        
        format = "<label>";
        format-foreground = "${secondary}";
        label = "%title%";
        label-maxlen = 5;
      };

      "global/wm" = {
        margin-top = "10";
        # margin-bottom = "5";
      };


      # "settings" = {
      #   # Reload when the screen configuration changes (XCB_RANDR_SCREEN_CHANGE_NOTIFY event)
      #   screenchange-reload = true;

      #   # Compositing operators
      #   # see: https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-operator-t
      #   compositing-background = "dest"; # source
      #   compositing-foreground = "dest"; # over
      #   compositing-overline = "dest"; # over
      #   compositing-underline = "dest"; # over
      #   compositing-border = "dest"; # over

      #   # Define fallback values used by all module formats
      #   # format-foreground = 
      #   # format-background = 
      #   # format-underline =
      #   # format-overline =
      #   # format-spacing =
      #   # format-padding =
      #   # format-margin =
      #   # format-offset =

      #   # Enables pseudo-transparency for the bar
      #   # If set to true the bar can be transparent without a compositor.
      #   pseudo-transparency = false;
      # };
    };
  };
}
