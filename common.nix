{ ... }:
{
  imports = [
    ./modules/usermod/aerc
    ./modules/usermod/email
    ./modules/usermod/gpg
    ./modules/usermod/neovim
    ./modules/usermod/offlineimap
    ./modules/usermod/git.nix
    ./modules/usermod/shell.nix
    ./modules/usermod/ssh.nix
  ];

  usermod.email.enable = true;
  usermod.gpg.enable = true;
  usermod.neovim.enable = true;
  usermod.git.enable = true;
  usermod.shell.enable = true;
  usermod.ssh.enable = true;
}
