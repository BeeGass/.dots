#{config, pkgs, ...}:
#
#{
#programs.hyprland = {
#    enable = true;
#    xwayland.enable = true;
#    #nvidiaPatches = true;
#  };
#}

{config, pkgs, ... }: 
{
wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    
    # The hyprland package to use
    package = pkgs.hyprland;i
    
    # Whether to enable XWayland
    xwayland.enable = true;

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
  };
  # ...
}
