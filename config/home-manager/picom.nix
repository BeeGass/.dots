{ pkgs, lib, ... }:

{
  services.picom = {
    enable = true;

    # Backend and sync settings
    backend = "glx";
    vSync = true;

    # Disable shadows and fading
    shadow = false;
    fade = false;

    # Opacity settings
    inactiveOpacity = 1.0;
    activeOpacity = 1.0;

    # Opacity rules for terminal emulators
    opacityRules = [
      "80:class_g = 'kitty'"
      "80:class_g = 'org.wezfurlong.wezterm'"
    ];

    # Additional settings
    settings = {
      daemon = true;
    };
  };
}
