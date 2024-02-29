{pkgs, ...}: {

programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
	"git"
	"tmux"
      ];
      theme = "p10k";
    };
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake /etc/nixos/#default";
      "n" = "nvim";
    };
    initExtraFirst = ''
	export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';
  };
}
