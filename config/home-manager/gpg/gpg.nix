{
    programs.gpg = {
        enable = true;
	publicKeys = [
	    { source = ./beegass.gpg; trust = 5;}  
	];
    };
}
