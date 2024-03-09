{ pkgs, ... }:

{
services.picom = {
    enable = true;
    shadow = true;
    #shadowOffsets = { [ -15 -15 ] };
    shadowOpacity = 0.75;
    opacityRules = [ 
      #"100:name = 'Picture in picture'"
      #"100:name = 'Picture-in-Picture'"
      #"85:class_i ?= 'rofi'"
      "100:class_i *= 'discord'"
      "80:class_i *= 'kitty'"
      "80:class_i *= 'vscode'"
      #"100:fullscreen"
    ];
    backend = "glx"; # Glx or Xrender
    vSync = true; # Fix Screen Tearing
    settings = {
      daemon = true;
      use-damage = false; # Fixes Flickering
      resize-damage = 1;
      refresh-rate = 0;
      corner-radius = 10; # Corners
      round-borders = 5;

      #animations = true; # Animations Pijulius
      #animation-window-mass = 0.5;
      #animation-for-open-window = "zoom";
      #animation-stiffness = 350;
      #animation-clamping = false;
      #fade-out-step = 1;

      transition-length = 150; # Animations Jonaburg
      transition-pow-x = 0.5;
      transition-pow-y = 0.5;
      transition-pow-w = 0.5;
      transition-pow-h = 0.5;
      size-transition = true;
      
      detect-rounded-corners = true; # Extras
      detect-client-opacity = false;
      detect-transient = true;
      detect-client-leader = false;
      mark-wmwim-focused = true;
      mark-ovredir-focues = true;
      unredir-if-possible = true;
      glx-no-stencil = true;
      glx-no-rebind-pixmap = true;
    };
  };
}
