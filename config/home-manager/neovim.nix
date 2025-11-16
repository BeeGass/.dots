{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    withPython3 = true;
    withNodeJs = true;  # Needed for some plugins like markdown-preview

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # LSP and tooling packages
    extraPackages = with pkgs; [
      # Language servers
      python-lsp-server
      typescript-language-server
      nodePackages.bash-language-server
      nodePackages.yaml-language-server
      nodePackages.vscode-langservers-extracted  # HTML, CSS, JSON

      # Python tools
      ruff
      mypy
      black

      # Other tools
      ripgrep  # For vim-ripgrep
      fzf      # Fuzzy finder
      nodejs   # For various plugins
      yarn     # For markdown-preview
    ];
  };

  # Symlink vimrc to use existing comprehensive configuration
  # This keeps all plugin management via Vim-Plug while ensuring LSP tools are available
  home.file.".vimrc".source = ./assets/vim/vimrc;

  # Ensure vim-plug is available for plugin management
  home.file.".vim/autoload/plug.vim" = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim";
      sha256 = "sha256-RucXX1SfDrnLk1GZkMfAx8u/RPdpnDq4oeFjnS3Z/Pg=";
    };
  };
}
