# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
     };
     grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 10;
      };
  };
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ];

  boot.kernelModules = [ "uinput" ];

  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "acpi_backlight=native"
    "nvidia.NVreg_EnableBacklightHandler=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input"
  '';

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  services.tumbler.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.flatpak.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    powerManagement.enable = true;
  };

  programs.gpu-screen-recorder.enable = true;

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    kitty
    waybar
    awww
    vim
    git
    wget
    curl
    fastfetch
    firefox
    unzip
    fd
    ripgrep
    lua-language-server
    stylua
    nil
    gcc
    gnumake
    binutils
    zoom-us
    ffmpegthumbnailer
    rofi
    gpu-screen-recorder-gtk
    mpv
    ydotool
    wf-recorder
    ffmpeg
    protonup-qt
    lutris
    bottles
    heroic
    gamescope
  ];

  programs.ydotool.enable = true;

  time.timeZone = "Europe/Kyiv";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
    LC_MONETARY = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_TIME = "uk_UA.UTF-8";
  };

  services.xserver.xkb = {
    layout = "ru";
    variant = "";
  };

  users.users.rassvet = {
    isNormalUser = true;
    description = "rassvet";
    extraGroups = [ "networkmanager" "wheel" "ydotool" "input" ];
    packages = with pkgs; [];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.displayManager = {
    enable = true;
    defaultSession = "hyprland-uwsm";

    sddm = {
      enable = true;
      wayland.enable = true;
    };

    autoLogin = {
      enable = true;
      user = "rassvet";
    };
  };

  system.stateVersion = "25.11";
}
