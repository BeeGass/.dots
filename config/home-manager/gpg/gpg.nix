{
    programs.gpg = {
        enable = true;
        publicKeys = [
            { source = ./beegass.gpg; trust = 5;}
        ];
        settings = {
            use-agent = true;
            default-key = "AA04 1AF7 AE32 714F 9D79 3335 A342 00D8 28A7 BB26";
            default-recipient-self = true;

            # Key discovery and retrieval
            auto-key-locate = "local,wkd,keyserver";
            keyserver = "hkps://keys.openpgp.org";
            auto-key-retrieve = true;
            auto-key-import = true;
            keyserver-options = "honor-keyserver-url";

            # Security enhancements
            no-emit-version = true;
            personal-cipher-preferences = "AES256 AES192 AES CAST5";
            personal-digest-preferences = "SHA512 SHA384 SHA256 SHA224";
            cert-digest-algo = "SHA512";
            default-preference-list = "SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed";

            # Display options
            list-options = "show-uid-validity show-unusable-subkeys";
            verify-options = "show-uid-validity";
        };
    };
}
