self: super: {
  gnome = super.gnome.overrideScope' (gfinal: gprev: {
    gnome-keyring = gprev.gnome-keyring.overrideAttrs (oldAttrs: {
      configureFlags = oldAttrs.configureFlags or [] ++ [
        "--disable-ssh-agent"
      ];
    });
  });
}

