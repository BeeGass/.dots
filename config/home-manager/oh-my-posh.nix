{ pkgs, ... }:

{
  # Install oh-my-posh
  home.packages = with pkgs; [
    oh-my-posh
  ];

  # Symlink theme configuration
  home.file.".config/oh-my-posh/config.json".source =
    ./assets/oh-my-posh/config.json;

  # Note: oh-my-posh initialization is handled in zsh.nix via programs.zsh.initExtra
}
