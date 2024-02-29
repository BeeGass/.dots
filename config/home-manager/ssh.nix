{
programs.ssh = {
	enable = true;
	matchBlocks = {
	    "github" = {
		user = "git";
		hostname = "github.com";
		identitiesOnly = true;
		identityFile = "~/.ssh/ssh_yk.pub";
	    };
	    "mydesktop" = {
		user = "beegass";
		hostname = "130.44.135.194";
		port = 7569;
	    };
	};
    };
}
