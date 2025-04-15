# { config, pkgs, lib, ... }:

# {
#   config = lib.mkIf config.boot.loader.grub.enable {
#     boot.loader.grub = {
#       # useGraphicalConsole = true;
#       # theme = handled by grub2-theme module if used, or set theme package here otherwise
#       gfxmodeEfi = "auto"; # Or your preferred resolution "1920x1080x32", etc.
#       gfxmodeBios = "auto"; # Or your preferred resolution "1920x1080x32", etc.
#       timeout = 10; # 10 seconds
#       timeoutStyle = "menu"; 
#       useOSProber = true; # Keep if you might dual boot
#       default = 0; # boot into latest kernel by default
#       # efiSupport = true; # Enable this if you intend to use GRUB for UEFI
#       # REMOVE device setting from here
#     };

#     # Theme settings module (if using vinceliuice)
#     boot.loader.grub2-theme = lib.mkIf (config.boot.loader.grub.theme == null) { # Only apply if default theme isn't set
#       enable = true;
#       theme = "whitesur";
#       icons = "whitesur";
#       screen = "1080p"; # Or use customResolution
#       # customResolution = "1920x1080x32";

#       # Optional: Show OS icons (if theme supports it well)
#       osIcons = true;

#       # Optional: Show a simple footer text
#       # footer = true;
#     };
#   };
# }

{ config, pkgs, lib, ... }:

{
  # Define base GRUB settings that apply WHEN grub is enabled
  boot.loader.grub = {
    # useGraphicalConsole = true; # Removed - implied by gfxmode/theme

    gfxmodeEfi = lib.mkForce "auto";
    gfxmodeBios = lib.mkForce "auto";

    timeout = lib.mkForce 10;
    timeoutStyle = "menu";

    default = 0;
    useOSProber = true; # Set to false if you never dual boot
  };

  # Define the theme module settings directly.
  # The 'enable = true;' inside should activate it only when
  # the parent boot.loader.grub is also enabled and active.
  # REMOVE the surrounding lib.mkIf (...) { ... };
  boot.loader.grub2-theme = {
    enable = true; # Enable the theme settings
    theme = "whitesur";
    # icons = "whitesur";
    screen = "1080p";
    # customResolution = "1920x1080x32";
    # osIcons = true;
  };

}
