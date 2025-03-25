{
  programs.git = {
    enable = true;
    userEmail = "bryank123@live.com";
    userName = "BeeGass";
    difftastic.enable = true;

    extraConfig = {
      commit = {
        verbose = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;  # Auto-setup remote tracking
      };
      pull = {
        rebase = true;  # Use rebase instead of merge by default
      };
      init = {
        defaultBranch = "main";  # Set default branch name
      };
    };

    signing = {
      key = "0xA34200D828A7BB26";
      signByDefault = true;
    };
  };
}
