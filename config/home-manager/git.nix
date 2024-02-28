{
  programs.git = {
    enable = true;
    userEmail = "bryank123@live.com";
    userName = "Bryan Gass";
    difftastic.enable = true;
    extraConfig = {commit = {verbose = true;};};
    signing = {
      key = "0xA34200D828A7BB26";
      signByDefault = true;
    };
  };
}
