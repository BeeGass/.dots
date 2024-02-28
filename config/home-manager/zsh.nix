{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
	"git"
	"tmux"
      ];
      theme = "powerlevel10k/powerlevel10k";
    };
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/dots";
      n = "nvim";
    };
  };
}
