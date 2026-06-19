{
  description = "flake for nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    hyprpolkitagent.url = "github:hyprwm/hyprpolkitagent";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    hyprpolkitagent.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, catppuccin, zen-browser, hyprpolkitagent, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };

        modules = [
          { 
            nixpkgs.config.allowUnfree = true;
          } 
          ./configuration.nix
          ./fish-system.nix
          home-manager.nixosModules.home-manager

          {
            services.power-profiles-daemon.enable = true;
            services.tlp.enable = false;

            programs.hyprland = {
              enable = true;
              withUWSM = true;
              package = nixpkgs.legacyPackages."x86_64-linux".hyprland;
              portalPackage = nixpkgs.legacyPackages."x86_64-linux".xdg-desktop-portal-hyprland;
            };

            xdg.portal = {
              enable = true;
              wlr.enable = false;
              extraPortals = [
                nixpkgs.legacyPackages."x86_64-linux".xdg-desktop-portal-gtk
              ];
              config.common.default = [ "hyprland" "gtk" ];
            };
          }

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };

            home-manager.users.rassvet = { pkgs, ... }: {

              imports = [
                inputs.catppuccin.homeModules.catppuccin
              ];

              home.username = "rassvet";
              home.homeDirectory = "/home/rassvet";

              wayland.windowManager.hyprland = {
                enable = true;
                package = pkgs.hyprland;
                configType = "lua";
                systemd.enable = false; 
              };

              xdg.configFile."hypr/hyprland.lua".enable = false;

              fonts.fontconfig.enable = true;
              programs.home-manager.enable = true;
              services.easyeffects.enable = true;
              catppuccin.flavor = "mocha";
              catppuccin.enable = true;
              services.swaync.enable = true;

              home.packages = with pkgs; [
                zen-browser.packages."x86_64-linux".default
                nerd-fonts.jetbrains-mono
                inputs.hyprpolkitagent.packages."x86_64-linux".default
                anyrun
                mako
                hyprlock
                nwg-look
                rose-pine-cursor
                catppuccin-gtk
                catppuccin
                rose-pine-hyprcursor
                swaynotificationcenter
                fuzzel
                kdePackages.dolphin
                cava
                power-profiles-daemon
                ayugram-desktop
                vesktop
                prismlauncher
                brightnessctl
                grim
                slurp
                wl-clipboard
                nh
                p7zip
                zip
                btop-cuda
                python313
                mangohud
                thunar
                waypaper
                element-desktop
                pavucontrol
                gpick
                (catppuccin-gtk.override {
                  accents = [ "lavender" ];
                  size = "standard";
                  variant = "mocha";
                })
              ];

              home.stateVersion = "25.11";
            };
          }
        ];
      };
    };
  };
}
