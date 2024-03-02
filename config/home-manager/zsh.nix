{pkgs, lib, ...}: 

{
programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting = {
	enable = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
	"git"
	"tmux"
      ];
    };
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/dots/#default";
      "n" = "nvim";
    };
    initExtraFirst = ''
	export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';
    plugins = [
      {
	  name = "powerlevel10k";
	  src = pkgs.zsh-powerlevel10k;
	  file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
	  name = "powerlevel10k-config";
	  src = lib.cleanSource ./p10k-config;
 	  file = ".p10k.zsh";
      }
    ];
  };
}
