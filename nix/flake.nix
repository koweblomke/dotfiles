{
  description = "Koweblomke nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix4vscode.url = "github:nix-community/nix4vscode";
    nix4vscode.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nix-homebrew,
      nix4vscode,
    }:
    let
      username = "renewerk";
      homeDir = /Users/renewerk;

      darwinConfig =
        { pkgs, config, ... }:
        {

          nixpkgs.config.allowUnfree = true;

          system.primaryUser = "renewerk";

          users.users.${username} = {
            home = homeDir;
          };

          nixpkgs.overlays = [ nix4vscode.overlays.forVscode ];

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget

          environment.systemPackages = with pkgs; [
            nixfmt-rfc-style
            vim
            mkalias
            fzf
            gum
            kind
            kubectl
            upbound
            crossplane-cli
            kubernetes-helm
            kyverno-chainsaw
            kcl
            yq-go
            oh-my-zsh
            zsh-powerlevel10k
            vscode
            krew
          ];

          fonts.packages = with pkgs; [ nerd-fonts.meslo-lg ];

          homebrew = {
            enable = true;
            brews = [
              "aws-iam-authenticator"
              "aws-vault"
              "jq"
              "terraform"
              "helm"
              "python@3"
              "virtualenvwrapper"
              "kcl-lang/tap/kcl-lsp"
              "derailed/k9s/k9s"
              "viddy"
              "pipx"
            ];
            casks = [
              "docker"
              "ollama"
              "iterm2"
            ];
            taps = [
              "kcl-lang/tap"
              "derailed/k9s"
            ];
            onActivation.cleanup = "zap";
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
          };

          system.activationScripts.applications.text =
            let
              env = pkgs.buildEnv {
                name = "system-applications";
                paths = config.environment.systemPackages;
                pathsToLink = "/Applications";
              };
            in
            pkgs.lib.mkForce ''
              # Set up applications.
              echo "setting up /Applications..." >&2
              rm -rf /Applications/Nix\ Apps
              mkdir -p /Applications/Nix\ Apps
              find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
              while read -r src; do
                app_name=$(basename "$src")
                echo "copying $src" >&2
                ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
              done
            '';

          system.defaults = {
            dock.autohide = true;
            dock.persistent-apps = [
              "/System/Applications/System Settings.app"
              "/Applications/Google Chrome.app"
              "/Applications/Microsoft Outlook.app"
              "/Applications/Microsoft Teams.app"
              "/Applications/Slack.app"
              "/Applications/AWS VPN Client/AWS VPN Client.app"
              "${pkgs.vscode}/Applications/Visual Studio Code.app"
              "/Applications/iTerm.app"
            ];
          };

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
      homeConfig =
        { pkgs, lib, ... }:
        {
          home.username = username;
          home.homeDirectory = homeDir;

          programs.vscode = {
            enable = true;

            profiles.default = {
              enableUpdateCheck = false; # Disable VSCode self-update and let Home Manager to manage VSCode versions instead.
              enableExtensionUpdateCheck = false; # Disable extensions auto-update and let nix4vscode manage updates and extensions

              userSettings = {
                # This property will be used to generate settings.json:
                # https://code.visualstudio.com/docs/getstarted/settings#_settingsjson
                "editor.formatOnSave" = true;
                "editor.cursorBlinking" = "phase";
                "editor.cursorSmoothCaretAnimation" = "on";
                "workbench.colorTheme" = "Palenight Theme";
                "security.workspace.trust.untrustedFiles" = "open";
                "git.confirmSync" = false;
                "git.enableSmartCommit" = true;
              };
              keybindings = [
                # See https://code.visualstudio.com/docs/getstarted/keybindings#_advanced-customization
                {
                  key = "shift+cmd+j";
                  command = "workbench.action.focusActiveEditorGroup";
                  when = "terminalFocus";
                }
              ];
              extensions = pkgs.nix4vscode.forVscode [
                "jnoortheen.nix-ide"
                "continue.continue"
                "pkief.material-icon-theme"
                "whizkydee.material-palenight-theme"
                "ms-python.python"
                "esbenp.prettier-vscode"
                "mohsen1.prettify-json"
                "eamodio.gitlens"
                "ms-vscode-remote.remote-ssh"
              ];
            };
          };
          programs.zsh = {
            enable = true;
            dotDir = ".config/zsh";
            # syntaxHighlighting.enable = true;
            autocd = true;
            autosuggestion.enable = true;
            initContent =
              let
                zshConfigEarlyInit = lib.mkOrder 500 ''
                  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
                  # Initialization code that may require console input (password prompts, [y/n]
                  # confirmations, etc.) must go above this block; everything else may go below.
                  if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
                    source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
                  fi
                '';
                zshConfig = lib.mkOrder 1000 ''
                  source virtualenvwrapper.sh
                  export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
                  source $HOME/.local/pipx/venvs/aws-sso-config/share/_aws_sso_config
                '';
              in
              lib.mkMerge [
                zshConfigEarlyInit
                zshConfig
              ];
            oh-my-zsh = {
              enable = true;
              plugins = [
                "git"
                "python"
                "virtualenv"
                "kubectl"
                "terraform"
                "aws"
              ];
            };
            plugins = [
              {
                name = "powerlevel10k-config";
                src = ./p10k;
                file = "p10k.zsh";
              }
              {
                name = "zsh-powerlevel10k";
                src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
                file = "powerlevel10k.zsh-theme";
              }
            ];
          };
          home.stateVersion = "24.11";
        };
    in
    {
      darwinConfigurations."macwerk" = nix-darwin.lib.darwinSystem {
        modules = [
          darwinConfig
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = homeConfig;
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "renewerk";

              # Automatically migrate existing Homebrew installations
              autoMigrate = true;
            };
          }
        ];
      };
      darwinPackages = self.darwinConfigurations."macwerk".pkgs;
    };
}
