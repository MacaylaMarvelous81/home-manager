{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jomarm";
  home.homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/jomarm" else "/home/jomarm";

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
    (pkgs.symlinkJoin (
    let
      sources = import ./npins;
      home-manager = config.programs.home-manager.package;
    in {
      inherit (home-manager) name meta;
      paths = [ home-manager ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
      wrapProgram $out/bin/home-manager \
        --prefix NIX_PATH : nixpkgs=${ sources.nixpkgs }:home-manager=${ sources.home-manager }
      '';
    }))
    (pkgs.symlinkJoin (
      let
        neovim = pkgs.neovim.override { withNodeJs = true; };
      in {
        inherit (neovim) name meta;
        paths = [ neovim ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/nvim \
            --prefix PATH : ${ lib.makeBinPath [ pkgs.nixd pkgs.deadnix pkgs.statix ] }
        '';
      }
    ))
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
  };

  xdg.configFile = {
    "nvim/.luarc.json".source = ./nvim/.luarc.json;
    "nvim/.neoconf.json".source = ./nvim/.neoconf.json;
    "nvim/.stylua.toml".source = ./nvim/.stylua.toml;
    "nvim/init.lua".source = ./nvim/init.lua;
    "nvim/lua".source = ./nvim/lua;
    "nvim/lazy-lock.fixed.json" = {
      source = ./nvim/lazy-lock.fixed.json;
      onChange = ''
      install -m 0644 ${ ./nvim/lazy-lock.fixed.json } ${ config.xdg.configHome }/nvim/lazy-lock.json
      '';
    };
    "nvim/neovim.yml".source = ./nvim/neovim.yml;
    "nvim/selene.toml".source = ./nvim/selene.toml;
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
    DIFFPROG = "${pkgs.neovim}/bin/nvim -d";
  };

  home.sessionPath = ["$HOME/bin" "$HOME/.local/bin" ];

  systemd.user.sessionVariables = {
    VINTAGE_STORY = "/home/jomarm/.local/share/vintagestory";
  };

  accounts.email.certificatesFile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  accounts.email.accounts = {
    "jomarm" = {
      address = "jomarm@jomarm.com";
      gpg = {
        encryptByDefault = true;
        key = "6AC46A6F9A5618D8";
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
      passwordCommand = "${pkgs.gnupg}/bin/gpg --decrypt ~/.secrets/email/jomarm";
      primary = true;
      realName = "Jomar Milan";

      # offlineimap = {
      #   enable = pkgs.stdenv.hostPlatform.isLinux;
      #   postSyncHookCommand = ./scripts/jomarm-postsynchook;
      # };
      aerc = {
        enable = pkgs.stdenv.hostPlatform.isLinux;
        extraAccounts = {
          pgp-opportunistic-encrypt = true;
          pgp-auto-sign = true;
          signature-file = ./email/jomarm-sig;
        };
        extraBinds = {
          view.ga = ":pipe -mb git am -3<Enter>";
        };
      };
    };
  };

  # Let Home Manager install and manage itself.
  # Managed using home.packages above instead.
  programs.home-manager.enable = false;

  programs.zsh.enable = true;
  programs.bash.enable = true;
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user = {
        name = "Jomar Milan";
        email = "jomarm@jomarm.com";
	signingkey = "F954C5C95AE7A312183DA76C6AC46A6F9A5618D8";
      };
      tag = {
      	gpgsign = true;
	forcesignannotated = true;
      };
      sendemail = {
      	smtpencryption = "ssl";
	smtpserver = "smtp.emailarray.com";
	smtpuser = "jomarm@jomarm.com";
      };
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
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        userKnownHostsFile = "~/.ssh/known_hosts";
	controlPath = "~/.ssh/master-%r@%n:%p";
      };
    };
  };
  programs.neovim = {
    enable = false;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      blink-cmp
      nvim-highlight-colors
      snacks-nvim
      which-key-nvim
      neo-tree-nvim
      plenary-nvim
      nui-nvim
      aerial-nvim
      nvim-lspconfig
    ];
  };

  services.psd = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    browsers = [ "firefox "];
  };
  services.gpg-agent = {
    enable = true;
    enableBashIntegration = true;
    enableExtraSocket = true;
    enableZshIntegration = true;
    pinentry.package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-qt;
  };
}
