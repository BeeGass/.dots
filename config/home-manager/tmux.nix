{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";

    # Prefix key: Ctrl+Space
    prefix = "C-Space";

    # General settings
    baseIndex = 1;  # Start windows at 1 instead of 0
    terminal = "tmux-256color";
    historyLimit = 10000;
    escapeTime = 0;  # Reduce escape time for faster key response
    keyMode = "vi";  # Use vim keybindings in copy mode
    mouse = true;    # Enable mouse support

    # Appearance
    clock24 = false;

    # Plugins (Nix-managed)
    plugins = with pkgs.tmuxPlugins; [
      sensible       # Sensible tmux defaults
      resurrect      # Save/restore sessions
      continuum      # Auto-save sessions
      cpu            # CPU/RAM monitoring
      sidebar        # Directory tree sidebar
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
      {
        plugin = cpu;
        extraConfig = ''
          set -g @cpu_low_icon "="
          set -g @cpu_medium_icon "≡"
          set -g @cpu_high_icon "≣"
          set -g @cpu_percentage_format "%3.0f%%"
          set -g @ram_percentage_format "%3.0f%%"
        '';
      }
      {
        plugin = sidebar;
        extraConfig = ''
          set -g @sidebar-tree-position 'right'
          set -g @sidebar-tree-width '60'
        '';
      }
    ];

    extraConfig = ''
      # ================================================
      # TERMINAL & COLOR SETTINGS
      # ================================================

      # Truecolor support
      set -as terminal-overrides ',*:RGB'
      set -ga terminal-overrides ",xterm-kitty:RGB"
      set -g xterm-keys on

      # Platform-aware terminal
      if-shell '[ -n "$TERMUX_VERSION" ]' \
        'set -g default-terminal "xterm-256color"' \
        'if-shell "infocmp -x tmux-256color >/dev/null 2>&1" \
           "set -g default-terminal tmux-256color" \
           "set -g default-terminal screen-256color"'

      # Send Ctrl+Space twice to send literal Ctrl+Space to applications
      bind-key C-Space send-prefix

      # ================================================
      # GENERAL SETTINGS
      # ================================================

      # Allow passthrough for tmux 3.4+
      if-shell 'tmux -V | grep -qE " 3\.(4|[5-9])| [4-9]\."' 'set -g allow-passthrough on'

      # Start panes at 1 instead of 0
      setw -g pane-base-index 1

      # Automatically renumber windows when one is closed
      set -g renumber-windows on

      # Set terminal title
      set -g set-titles on
      set -g set-titles-string '#h ❐ #S ● #I #W'

      # Repeat time for keys bound with -r
      set -g repeat-time 500

      # ================================================
      # APPEARANCE & STATUS BAR
      # ================================================

      # Status bar - modern modular design with transparency
      set -g status on
      set -g status-interval 1
      set -g status-position bottom
      set -g status-style 'bg=default fg=#a8a8a8'

      # Left side - compact prefix indicator
      set -g status-left '#{?client_prefix,#[bg=#9d7cd8]#[fg=#1a1a1a] ◆ #[bg=default] ,}'
      set -g status-left-length 10

      # Right side - hardware stats, session, time, hostname
      if -F '#{==:#{env:BEEGASS_GPU_ENABLED},}' 'setenv -g BEEGASS_GPU_ENABLED 0'
      set -g status-right '#(~/.tmux/plugins/tmux-cpu/scripts/cpu_ram_bars.sh)#{?#{==:#{env:BEEGASS_GPU_ENABLED},1}, #(node ~/.tmux/plugins/tmux-gpu/gpu.js), }                                                              #[bg=#1a1a1a]#[fg=#686868]  #[fg=#a8a8a8]#S #[bg=#2a2a2a]#[fg=#686868]  #[fg=#a8a8a8]%l:%M %p #[bg=#333333]#[fg=#f7ca88]  #h '
      set -g status-right-length 250

      # Window status - modular pills with icons
      setw -g window-status-current-style 'fg=#1a1a1a bg=#f7ca88 bold'
      setw -g window-status-current-format '#[fg=#f7ca88]#[bg=#f7ca88]#[fg=#1a1a1a] #I  #W #[fg=#f7ca88]#[bg=default]'

      setw -g window-status-style 'fg=#686868 bg=#2a2a2a'
      setw -g window-status-format '#[fg=#2a2a2a]#[bg=#2a2a2a]#[fg=#686868] #I  #W #[fg=#2a2a2a]#[bg=default]'

      # Window status settings
      setw -g window-status-separator ' '
      set -g status-justify left

      # Pane borders
      set -g pane-border-style 'fg=#333333'
      set -g pane-active-border-style 'fg=white'

      # Command/message line
      set -g message-style 'fg=white bg=black bold'
      set -g message-command-style 'fg=white bg=black bold'

      # ================================================
      # KEY BINDINGS
      # ================================================

      # === PANE MANAGEMENT ===

      # Split panes using | and - (maintain current directory)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Navigate panes using arrow keys
      bind Left select-pane -L
      bind Down select-pane -D
      bind Up select-pane -U
      bind Right select-pane -R

      # Resize panes using Shift + arrow keys
      bind -r S-Left resize-pane -L 5
      bind -r S-Down resize-pane -D 5
      bind -r S-Up resize-pane -U 5
      bind -r S-Right resize-pane -R 5

      # Quick pane selection
      bind q display-panes

      # Swap panes
      bind > swap-pane -D
      bind < swap-pane -U

      # === WINDOW (TAB) MANAGEMENT ===

      # Create new window in current directory
      bind c new-window -c "#{pane_current_path}"

      # Window navigation
      bind n next-window
      bind p previous-window
      bind l last-window

      # Direct window selection (0-9)
      bind 0 select-window -t :=0
      bind 1 select-window -t :=1
      bind 2 select-window -t :=2
      bind 3 select-window -t :=3
      bind 4 select-window -t :=4
      bind 5 select-window -t :=5
      bind 6 select-window -t :=6
      bind 7 select-window -t :=7
      bind 8 select-window -t :=8
      bind 9 select-window -t :=9

      # Window management
      bind w choose-window
      bind & kill-window
      bind , command-prompt -I "#W" "rename-window '%%'"

      # === SESSION MANAGEMENT ===

      bind s choose-session
      bind ( switch-client -p
      bind ) switch-client -n

      # === COPY MODE ===

      # Enter copy mode
      bind [ copy-mode
      bind Escape copy-mode

      # Copy mode key bindings (vim-style)
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi V send-keys -X select-line
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi Escape send-keys -X cancel

      # Paste buffer
      bind ] paste-buffer
      bind P paste-buffer

      # === OTHER USEFUL BINDINGS ===

      # Reload configuration
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

      # Toggle pane zoom
      bind z resize-pane -Z

      # Find session/window/pane
      bind f command-prompt -p find-session 'switch-client -t %%'

      # Kill current pane
      bind x kill-pane

      # Show all key bindings
      bind ? list-keys

      # Command prompt
      bind : command-prompt

      # Clock mode
      bind t clock-mode

      # ================================================
      # DIRECT KEYBINDINGS (NO PREFIX NEEDED!)
      # ================================================

      # Navigate panes with Alt+Arrow keys
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Switch windows with Alt+Number
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5

      # Quick window navigation with Alt+h/l
      bind -n M-h previous-window
      bind -n M-l next-window

      # Create new window with Alt+c
      bind -n M-c new-window -c "#{pane_current_path}"

      # Split panes directly with Alt+| and Alt+-
      bind -n 'M-\' split-window -h -c "#{pane_current_path}"
      bind -n M-- split-window -v -c "#{pane_current_path}"

      # Toggle zoom with Alt+z
      bind -n M-z resize-pane -Z

      # Close current pane with Alt+q
      bind -n M-q kill-pane

      # Reload tmux config with Alt+r
      bind -n M-r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

      # ================================================
      # COPY & PASTE SETTINGS
      # ================================================

      # Choose system clipboard based on available tools
      if-shell 'command -v pbcopy >/dev/null' \
        'set -g @copy "pbcopy"; set -g @paste "pbpaste"'
      if-shell 'command -v wl-copy >/dev/null' \
        'set -g @copy "wl-copy"; set -g @paste "wl-paste -n"'
      if-shell 'command -v xclip >/dev/null' \
        'set -g @copy "xclip -in -selection clipboard"; set -g @paste "xclip -out -selection clipboard"'
      if-shell 'command -v termux-clipboard-set >/dev/null' \
        'set -g @copy "termux-clipboard-set"; set -g @paste "termux-clipboard-get"'

      # y = copy via system clipboard
      unbind -T copy-mode-vi y
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "#{@copy}"

      # Termux clipboard bindings
      if-shell 'command -v termux-clipboard-set >/dev/null 2>&1' \
        'bind -n F12 if -F "#{pane_in_mode}" \
            "send-keys -X copy-pipe-and-cancel \"termux-clipboard-set\"" \
            "display-message \"Enter copy-mode (prefix [), select, then F12 to copy\""'

      if-shell 'command -v termux-clipboard-set >/dev/null 2>&1' \
        'bind -n S-F12 capture-pane -pS -100000 \| termux-clipboard-set \; display-message "Pane copied to clipboard"'

      # Paste helpers
      bind -n C-y run -b 'tmux save-buffer - | #{@copy}'
      bind -n C-v run -b '#{@paste} | tmux load-buffer - && tmux paste-buffer'

      # ================================================
      # MOUSE SETTINGS
      # ================================================

      # Right click to paste from tmux buffer
      bind-key -n MouseDown3Pane paste-buffer

      # Don't exit copy mode when dragging with mouse
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # ================================================
      # PERFORMANCE & BEHAVIOR SETTINGS
      # ================================================

      # Enable focus events (for vim, etc.)
      set -g focus-events on

      # Activity monitoring
      setw -g monitor-activity on
      set -g visual-activity off

      # Bell settings
      set -g visual-bell off
      set -g bell-action none

      # ================================================
      # ADVANCED FEATURES
      # ================================================

      # Display pane numbers longer
      set -g display-panes-time 2000

      # Pane number display colors
      set -g display-panes-active-colour white
      set -g display-panes-colour grey

      # Word separators for double-click selection
      set -g word-separators " -_@"
    '';
  };
}
