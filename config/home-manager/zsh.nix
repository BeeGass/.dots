{pkgs, lib, ...}: 

{
programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = false;
    enableAutosuggestions = true;
    syntaxHighlighting = {
      enable = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "tmux"
        "ssh-agent"
        "gpg-agent"
        # "uv"
        "aliases"
        "branch"
        "colorize"
        "gh"
        # "kitty"
        "sudo"
      ];
    };
    shellAliases = {
      "ls" = "ls --color --group-directories-first";
      "ll" = "ls -l --color --group-directories-first";
      "la" = "ls -lA --color --group-directories-first";
      # "ssh" = "kssh";
      update = "sudo nixos-rebuild switch --flake ~/.dots/#default";
      reboot = "sudo shutdown -r now";
      shutdown = "sudo shutdown now";
      "n" = "nvim";
    };
    initExtraFirst = ''
	    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';
    plugins = [
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = ".p10k.zsh";
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };
}
