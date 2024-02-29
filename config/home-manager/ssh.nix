{
programs.ssh = {
	enable = true;
	addKeysToAgent = "yes";
	matchBlocks = {
	    "github" = {
		user = "git";
		hostname = "github.com";
		identitiesOnly = true;
		identityFile = "~/.ssh/id_rsa_yubikey.pub";
	    };
	    "mydesktop" = {
		user = "beegass";
		hostname = "130.44.135.194";
		port = 7569;
	    };
	};
    };
}
