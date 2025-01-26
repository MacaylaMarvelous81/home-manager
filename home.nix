{ config, pkgs, homePath, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jomarm";
  home.homeDirectory = homePath;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    pkgs.neovim
    # mason and similar tools need node
    pkgs.nodejs_23
    pkgs.mosh
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".secrets".source = ./secrets;

    ".config/nvim".source = ./config/nvim;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jomarm/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  accounts.email.certificatesFile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  accounts.email.accounts = {
    "jomarm" = {
      address = "jomarm@jomarm.com";
      gpg = {
        encryptByDefault = true;
        key = "jomarm@jomarm.com";
        signByDefault = true;
      };
      imap = {
        host = "imap.emailarray.com";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "smtp.emailarray.com";
        port = 465;
        tls.enable = true;
      };
      userName = "jomarm@jomarm.com";
      passwordCommand = "gpg --decrypt ~/.secrets/email/jomarm";
      primary = true;
      realName = "Jomar Milan";
      msmtp.enable = true;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh.enable = true;
  programs.git = {
    enable = true;
    userName = "Jomar Milan";
    userEmail = "jomarm@jomarm.com";
    signing = {
      signByDefault = true;
      key = "F954C5C95AE7A312183DA76C6AC46A6F9A5618D8";
    };
    extraConfig = {
      init.defaultBranch = "master";
      tag.forceSignAnnotated = true;
      sendemail.identity = "jomarm";
      "diff \"json\"".textconv = "${pkgs.jq}/bin/jq .";
    };
  };
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = ./gpgkeys/F954C5C95AE7A312183DA76C6AC46A6F9A5618D8.asc;
        trust = "ultimate";
      }
    ];
  };
  programs.msmtp.enable = true;
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "nest" = {
        hostname = "hackclub.app";
        remoteForwards = [
          {
            bind.address = "/run/user/2376/gnupg/S.gpg-agent";
            host.address = "${homePath}/.gnupg/S.gpg-agent.extra";
          }
        ];
      };
    };
  };
}
