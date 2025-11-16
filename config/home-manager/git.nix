{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "bryank123@live.com";
    userName = "BeeGass";

    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = false;
        line-numbers = true;
      };
    };

    signing = {
      key = "0xACC3640C138D96A2";
      signByDefault = true;
    };

    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      clone = "!f() { if [ \"$#\" -eq 1 ]; then git -C \"$HOME/Projects\" clone \"$1\"; else git clone \"$@\"; fi; }; f";
    };

    extraConfig = {
      github = {
        user = "BeeGass";
      };
      commit = {
        verbose = true;
      };
      gpg = {
        program = "gpg";
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      pull = {
        rebase = false;
      };
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
      };
      interactive = {
        diffFilter = "delta --color-only";
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
      credential = {
        helper = "libsecret";
      };
      include = {
        path = "~/.gitconfig.local";
      };
    };
  };
}
