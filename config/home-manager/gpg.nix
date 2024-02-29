{
    programs.gpg = {
        enable = true;
	publicKeys = [
	    { source = ../../../../../home/beegass/.gnupg/beegass.gpg; trust = 5;}  
	];
    };
}
