{ pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;

    shellIntegration = {
      enableZshIntegration = true;
    };

    # Font configuration
    font = {
      name = "Google Sans Mono";
      size = 10;
    };

    # Color scheme: black background, white foreground
    settings = {
      foreground = "#ffffff";
      background = "#000000";

      # Opacity (requires X11 + picom compositor)
      background_opacity = "0.80";

      # Force X11 backend (disable Wayland) so picom can handle compositing
      linux_display_server = "x11";

      # Window decorations & padding
      window_padding_width = 10;

      # Tabs (hidden; using tmux instead)
      tab_bar_style = "hidden";

      # Cursor configuration
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";

      # Performance
      repaint_delay = 8;
      scrollback_lines = 10000;
      sync_to_monitor = "yes";

      # Auto-start tmux via login shell for proper PATH
      shell = "zsh -l -c \"tmux -u new-session -A -s main\"";
    };

    # Keybindings
    keybindings = {
      "f11" = "toggle_fullscreen";
    };

    # Extra configuration for right-click paste
    extraConfig = ''
      # Mouse: right-click paste
      mouse_map right press ungrabbed paste_from_clipboard
    '';
  };
}
