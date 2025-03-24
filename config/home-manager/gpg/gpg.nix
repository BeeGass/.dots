{
    programs.gpg = {
        enable = true;
		publicKeys = [
			{ source = ./beegass.gpg; trust = 5;}  
		];
		settings = {
			use-agent = true;
			# pinentry-mode = "loopback";
			default-key = "AA04 1AF7 AE32 714F 9D79  3335 A342 00D8 28A7 BB26";
			default-recipient-self = true;
			auto-key-locate = "local,wkd,keyserver";
			keyserver = "hkps://keys.openpgp.org";
			auto-key-retrieve = true;
			auto-key-import = true;
			keyserver-options = "honor-keyserver-url";
		};
    };
}
