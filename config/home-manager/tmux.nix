{ pkgs, ... }:

let
  zsh = \${pkgs.zsh}/bin/zsh;
in
{
programs.tmux = {
    enable = true;
    shell = ${zsh};
    };
}
