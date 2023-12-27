# Shipnix recommended settings
# IMPORTANT: These settings are here for ship-nix to function properly on your server
# Modify with care

{ config, pkgs, modulesPath, lib, ... }:
{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';
    settings = {
      trusted-users = [ "root" "ship" "nix-ssh" ];
    };
  };

  programs.git.enable = true;
  programs.git.config = {
    advice.detachedHead = false;
  };

  services.openssh = {
    enable = true;
    # ship-nix uses SSH keys to gain access to the server
    # Manage permitted public keys in the `authorized_keys` file
    settings.PasswordAuthentication = false;
  };


  users.users.ship = {
    isNormalUser = true;
    extraGroups = [ "wheel" "nginx" ];
    # If you don't want public keys to live in the repo, you can remove the line below
    # ~/.ssh will be used instead and will not be checked into version control. 
    # Note that this requires you to manage SSH keys manually via SSH,
    # and your will need to manage authorized keys for root and ship user separately
    openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXQUmWsLKHkC2xmebWXN0xLlus+8vqtJp7jSZgqaRLTbAfJ2oP61Al5swfDn3po864Eq0tGcj2tjdINuwKAXWY9Ql4mhTQAtf1e32s2CVfsVrRmXDLVwz87dDQkqvScz0151UlWOwHwmdlBAK4ili+jWsGMI/9jTQENDYzdf70hqIOUxq3H5uH4lN83+aMySZyWsoA4XUY+OKrRQKQAvjoMbGzDtEd2tDK5uIwyxpniJIr7WJJEd3Plfsa9QltLUG5xxaLLNIovODL7y/MTnKko9MsI0g0p+fDNYGGCxAGgE0YTWxDXckJFOfiqyhdTyac7tzOMNTZO1wl2I9waRRX/0HkPq5meC2YiXn+td2RR7OUHcY4dHFdOEcBfKak6Umqm9WAEfMnQ9d83eba0FrwAsnkVFgy62zdloMp3v89wY+PXbWh9rHeT6DDCoXTWYXQinjoaAGsxy+qr2QN9FEG9mnF3sQrj6jeDyXHeWColKmlbn3NDhnFNfZ3elaxtr8= ship@tite-ship
"
    ];
  };

  # Can be removed if you want authorized keys to only live on server, not in repository
  # Se note above for users.users.ship.openssh.authorizedKeys.keyFiles
  users.users.root.openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXQUmWsLKHkC2xmebWXN0xLlus+8vqtJp7jSZgqaRLTbAfJ2oP61Al5swfDn3po864Eq0tGcj2tjdINuwKAXWY9Ql4mhTQAtf1e32s2CVfsVrRmXDLVwz87dDQkqvScz0151UlWOwHwmdlBAK4ili+jWsGMI/9jTQENDYzdf70hqIOUxq3H5uH4lN83+aMySZyWsoA4XUY+OKrRQKQAvjoMbGzDtEd2tDK5uIwyxpniJIr7WJJEd3Plfsa9QltLUG5xxaLLNIovODL7y/MTnKko9MsI0g0p+fDNYGGCxAGgE0YTWxDXckJFOfiqyhdTyac7tzOMNTZO1wl2I9waRRX/0HkPq5meC2YiXn+td2RR7OUHcY4dHFdOEcBfKak6Umqm9WAEfMnQ9d83eba0FrwAsnkVFgy62zdloMp3v89wY+PXbWh9rHeT6DDCoXTWYXQinjoaAGsxy+qr2QN9FEG9mnF3sQrj6jeDyXHeWColKmlbn3NDhnFNfZ3elaxtr8= ship@tite-ship
"
  ];

  security.sudo.extraRules = [
    {
      users = [ "ship" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" "SETENV" ];
        }
      ];
    }
  ];
}
