{ pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;

    # Enable ZSH plugins via home-manager
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Note: history-substring-search is sourced from dotfiles/zsh/30-plugins.zsh

    # Shell aliases (minimal - more in dotfiles/zsh/40-aliases.zsh)
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/.dots/#default";
      reboot = "sudo shutdown -r now";
      shutdown = "sudo shutdown now";
      n = "nvim";
    };

    # Initialize oh-my-posh and source modular zsh files
    initExtra = ''
      # oh-my-posh initialization
      export OH_MY_POSH_CONFIG="$HOME/.config/oh-my-posh/config.json"
      if command -v oh-my-posh &> /dev/null; then
        eval "$(oh-my-posh init zsh --config "$OH_MY_POSH_CONFIG")"
      fi

      # oh-my-posh helper functions
      enable-transient-prompt() { oh-my-posh toggle transient-prompt; }
      reload-omp() { eval "$(oh-my-posh init zsh --config "$OH_MY_POSH_CONFIG")"; }
      edit-omp() { ''${EDITOR:-nvim} "$OH_MY_POSH_CONFIG"; }

      # Source modular zsh configuration files
      # Note: Skip 10-oh-my-posh.zsh (handled above) and 30-plugins.zsh (managed by Nix)
      source_if_exists() { [[ -f "$1" ]] && source "$1"; }

      source_if_exists "$HOME/.dots/config/home-manager/assets/zsh/00-init.zsh"
      source_if_exists "$HOME/.dots/config/home-manager/assets/zsh/20-environment.zsh"
      source_if_exists "$HOME/.dots/config/home-manager/assets/zsh/40-aliases.zsh"
      source_if_exists "$HOME/.dots/config/home-manager/assets/zsh/50-functions.zsh"
      source_if_exists "$HOME/.dots/config/home-manager/assets/zsh/60-claude.zsh"
      source_if_exists "$HOME/.dots/config/home-manager/assets/zsh/60-completions.zsh"
      source_if_exists "$HOME/.dots/config/home-manager/assets/zsh/70-keybindings.zsh"
      source_if_exists "$HOME/.dots/config/home-manager/assets/zsh/80-tools.zsh"
      source_if_exists "$HOME/.dots/config/home-manager/assets/zsh/90-local.zsh"
    '';

    history = {
      size = 10000;
      save = 10000;
      share = true;
      extended = true;
    };
  };

  # Symlink zshenv and zshrc to ensure proper loading
  home.file.".zshenv".source = ./assets/zsh/zshenv;
}
