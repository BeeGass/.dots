{ pkgs, ... }:
 
let
  background = "#2B3C6D"; # Navy blue
  foreground = "#F7D9D0"; # Pale pink
  primary = "#4DA88E"; # Teal green
  secondary = "#FBE870"; # Bright yellow
  accent = "#8C6C5E"; # Dusty brown

  fontSize = "10";
  font-0 = "Google Sans Mono monospacified for Google Sans Mono";
  font-1 = "Google Sans";
  font-2 = "TerminessNerdFont";
  font-3 = "Font Awesome 6 Free";
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
      polybar double-right-right &
      polybar double-right-left &
      polybar single-center &
      polybar double-left-right &
      polybar double-left-left &
    '';

    config = {

      ##########################################
      ################### Bars #################
      ##########################################

      "bar/double-right-right" = {
        bottom = false;
        fixed-center = true;
        override-redirect = true;
        
        width = "12%";
        height = 30;

        offset-x = "87%";
        offset-y = "1%";
              
        radius-top = "-60%";
        radius-bottom = "-60%";

        background = "${background}"; 
        foreground = "${foreground}";
        padding = 2;

        locale = "en_US.UTF-8";

        modules-left = "pulseaudio";
        modules-center = "battery";
        modules-right = "date";

        font-0 = "${font-0}:size=${fontSize};3";
        font-1 = "${font-1}:size=${fontSize};3";
        font-2 = "${font-2}:size=${fontSize};3";
        font-3 = "${font-3}:size=${fontSize};3";
      };

      "bar/double-right-left" = {
        bottom = false;
        fixed-center = true;
        override-redirect = true;
        
        width = "8%";
        height = 30;

        offset-x = "78%";
        offset-y = "1%";
              
        radius-top = "-60%";
        radius-bottom = "-60%";

        background = "${background}"; 
        foreground = "${foreground}";
        padding = 2;

        locale = "en_US.UTF-8";

        modules-left = "menu";
        modules-center = "cpu";
        # modules-right = "wlan";

        font-0 = "${font-0}:size=${fontSize};3";
        font-1 = "${font-1}:size=${fontSize};3";
        font-2 = "${font-2}:size=${fontSize};3";
        font-3 = "${font-3}:size=${fontSize};3";
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

        font-0 = "${font-0}:size=${fontSize};3";
        font-1 = "${font-1}:size=${fontSize};3";
        font-2 = "${font-2}:size=${fontSize};3";
        font-3 = "${font-3}:size=${fontSize};3";
      };

      "bar/double-left-right" = {
        bottom = false;
        fixed-center = true;
        override-redirect = true;
        
        width = "8%";
        height = 30;

        offset-x = "11%";
        offset-y = "1%";
              
        radius-top = "-60%";
        radius-bottom = "-60%";

        # background = "${background}"; 
        # foreground = "${foreground}";

        background = "#00282c34"; 
        foreground = "#00282c34";

        padding = 1;

        locale = "en_US.UTF-8";

        modules-left = "tray";

        font-0 = "${font-0}:size=${fontSize};3";
        font-1 = "${font-1}:size=${fontSize};3";
        font-2 = "${font-2}:size=${fontSize};3";
        font-3 = "${font-3}:size=${fontSize};3";
      };

      "bar/double-left-left" = {
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

        font-0 = "${font-0}:size=${fontSize};3";
        font-1 = "${font-1}:size=${fontSize};3";
        font-2 = "${font-2}:size=${fontSize};3";
        font-3 = "${font-3}:size=${fontSize};3";
      };

      "bar/dumb" = {
        override-redirect = false;
        bottom = false;
        fixed-center = true;
        wm-restack = "i3";

        width = "100%";
        height = 40; # 50

        #offset-x = "45%";
        #offset-y = "1%";

        radius-top = "-100%";
        radius-bottom = "-100%";

        # locale = "en_US.UTF-8";

        modules-center = "title-2";

        background = "#00282c34"; 
        foreground = "#00282c34";

        # background = "#ccFBE870"; 
        # foreground = "#ccFBE870";

        font-0 = "${font-0}:size=${fontSize};3";
        font-1 = "${font-1}:size=${fontSize};3";
        font-2 = "${font-2}:size=${fontSize};3";
        font-3 = "${font-3}:size=${fontSize};3";
      };

      ##########################################
      ################# Modules ################
      ##########################################

      "module/cpu" = {
        type = "internal/cpu";

        interval = 2;
        label-padding = 1;

        ramp-coreload-0 = "▁";
        ramp-coreload-1 = "▂";
        ramp-coreload-2 = "▃";
        ramp-coreload-3 = "▄";
        ramp-coreload-4 = "▅";
        ramp-coreload-5 = "▆";
        ramp-coreload-6 = "▇";
        ramp-coreload-7 = "█";

        ramp-coreload-0-foreground = "#B6B99D";
        ramp-coreload-1-foreground = "#B6B99D";
        ramp-coreload-2-foreground = "#A0A57E";
        ramp-coreload-3-foreground = "#DEBC9C";
        ramp-coreload-4-foreground = "#DEBC9C";
        ramp-coreload-5-foreground = "#D1A375";
        ramp-coreload-6-foreground = "#D19485";
        ramp-coreload-7-foreground = "#C36561";

        #label = "";
        label = " %percentage%";

        #format = "<label> <ramp-coreload>";
        format = "<label>";
      };

      "module/battery" = {
        type = "internal/battery";

        battery = "BAT0";
        adapter = "AC0";
        full-at = 98;

        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";

        ramp-capacity-0-foreground = "#B6B99D";
        ramp-capacity-1-foreground = "#B6B99D";
        ramp-capacity-2-foreground = "#A0A57E";
        ramp-capacity-3-foreground = "#DEBC9C";
        ramp-capacity-4-foreground = "#DEBC9C";
        # ramp-capacity-foreground = "${foreground}";

        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";

        animation-charging-0-foreground = "#B6B99D";
        animation-charging-1-foreground = "#B6B99D";
        animation-charging-2-foreground = "#A0A57E";
        animation-charging-3-foreground = "#DEBC9C";
        animation-charging-4-foreground = "#DEBC9C";
        # animation-charging-foreground = "${foreground}";
        
        animation-charging-framerate = "750";

        label-charging = "%percentage%";
        label-discharging = "%percentage%";

        format-charging = "<animation-charging> <label-charging>";
        format-discharging = "<ramp-capacity> <label-discharging>";
      };

      "module/date" = {
        type = "internal/date";

        interval = 1;

        date = "%b %d";
        date-alt = "%a %b %d";

        time = "%I:%M %p";
        time-alt = "%H:%M";

        label = " %time%";
        format = "<label>";
      };

      "module/tray" = {
        type = "internal/tray";

        tray-background = "#aa282c34"; 
        tray-foreground = "#aa282c34";

        # tray-background = "${background}";
        # tray-foreground = "${foreground}";

        tray-position = "left";
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
        label-mode-padding = 1;
        label-mode-background = "${primary}";

        label-focused = "%icon%";
        label-focused-foreground = "${secondary}";
        label-focused-background = "${background}";
        label-focused-padding = 1;

        label-unfocused = "%icon%";
        label-unfocused-foreground = "${foreground}";
        label-unfocused-background = "${background}";
        label-unfocused-padding = 1;

        label-visible = "%icon%";
        label-visible-foreground = "${foreground}";
        label-visible-background = "${background}";
        label-visible-padding = 1;

        label-urgent = "%icon%";
        label-urgent-foreground = "#ff0000";
        label-urgent-background = "${background}";
        label-urgent-padding = 1;

        label-separator = "|";
        label-separator-padding = 1;
        label-separator-foreground = "${foreground}";

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
        ws-icon-default = "";
      };

      #"module/memory" = {
      #  type = "internal/memory";
      #  interval = 3;
      #  format = " <label>";
      #  label = "%percentage_used%";
      #  label-padding = 1;
      #};

      "module/menu" = {
        type = "custom/menu";

        expand-right = true;

        # ---------
        # Powermenu
        # ---------
        menu-0-0 = "  "; # logout
        menu-0-0-exec = "menu-open-1";
        # menu-0-0-foreground = ${colors.urgent}

        menu-0-1 = "  "; # reboot
        menu-0-1-exec = "menu-open-2";
        # menu-0-1-foreground = ${colors.urgent}

        menu-0-2 = "  "; # shutdown
        menu-0-2-exec = "menu-open-3";
        # menu-0-2-foreground = ${colors.warning}

        # ------
        # Logout
        # ------
        menu-1-0 = "Logout";
        menu-1-0-exec = "i3-msg exit";
        # menu-1-1-foreground = ${colors.urgent}

        menu-1-1 = "Cancel";
        menu-1-1-exec = "menu-open-0";
        # menu-1-0-foreground = ${colors.success}

        # ------
        # Reboot
        # ------
        menu-2-0 = "Reboot";
        menu-2-0-exec = "systemctl reboot";
        # menu-2-0-foreground = ${colors.urgent}

        menu-2-1 = "Cancel ";
        menu-2-1-exec = "menu-open-0";
        # menu-2-1-foreground = ${colors.success}

        # --------
        # Shutdown
        # --------
        menu-3-0 = "Shutdown";
        menu-3-0-exec = "systemctl poweroff";
        # menu-3-0-foreground = ${colors.urgent}

        menu-3-1 = "Cancel";
        menu-3-1-exec = "menu-open-0";
        # menu-3-1-foreground = ${colors.success}

        # -----
        # Other
        # -----
        label-open = "";
        # label-open-foreground = "${foreground}";

        label-close = "";
        # label-close-foreground = "${foreground}";
        
        label-separator = "|";
        # label-separator-foreground = "${foreground}";
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";

        label-volume-padding = 1;
        label-muted-padding = 1;

        ramp-volume-0 = "";
        ramp-volume-1 = "";
        ramp-volume-2 = "";

        label-muted = " muted";

        label-volume = "%percentage%";
        format-volume = "<ramp-volume> <label-volume>";
      };

      "module/title" = {
        type = "internal/xwindow";
        
        format = "<label>";
        format-foreground = "${secondary}";
        label = "%title%";
        label-maxlen = 40;
      };

      "module/title-2" = {
        type = "internal/xwindow";
        
        format = "<label>";
        format-foreground = "${secondary}";
        label = "%title%";
        label-maxlen = 5;
      };

      "module/wlan" = {
        type = "internal/network";
        interface = "wlan1";
        interface-type = "wireless";
        interval = "3.0";

        label-connected = " %downspeed%";

        ramp-signal-0 = "▁";
        ramp-signal-1 = "▂";
        ramp-signal-2 = "▃";
        ramp-signal-3 = "▄";
        ramp-signal-4 = "▅";
        ramp-signal-5 = "▆";
        ramp-signal-6 = "▇";
        ramp-signal-7 = "█";

        ramp-signal-0-foreground = "#B6B99D";
        ramp-signal-1-foreground = "#B6B99D";
        ramp-signal-2-foreground = "#A0A57E";
        ramp-signal-3-foreground = "#DEBC9C";
        ramp-signal-4-foreground = "#DEBC9C";
        ramp-signal-5-foreground = "#D1A375";
        ramp-signal-6-foreground = "#D19485";
        ramp-signal-7-foreground = "#C36561";

        # format-connected = "<ramp-signal> <label-connected>"; 
        format-connected = "<label-connected>"; 
      };
    };
  };
}
