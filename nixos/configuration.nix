# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Nix daemon configuration
  nix.settings = {
    max-jobs = "auto"; 
    http-connections = 50; 
    connect-timeout = 60;
    stalled-download-timeout = 90;
    download-attempts = 5;
    experimental-features = [ "nix-command" "flakes" ];
  };

services.cloudflare-warp.enable = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Включение и настройка Bluetooth
  hardware.bluetooth.enable = true; # Включает Bluetooth
  hardware.bluetooth.powerOnBoot = true; # Автоматически включает питанием при загрузке
  services.blueman.enable = true; # Графический менеджер и менеджер подключений

  # Ядро и фиксы для Wi-Fi
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "pcie_aspm=off"
    "rtw89_core.disable_ps_mode=y"
    "rtw89pci.disable_aspm=y"      
  ];
  networking.networkmanager.wifi.powersave = false;

 

 
  # Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Переменные окружения для Wayland / NVIDIA
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
  };

  # Службы ASUS
  services.asusd.enable = true;
  programs.rog-control-center.enable = true;
  hardware.enableAllFirmware = true;

  # Shell / Часовой пояс и Локаль
  programs.fish.enable = true;
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_GB.UTF-8"; # <-- This forces date names/days of the week to English
   };

  # Графика и NVIDIA
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable = true; 
    enable32Bit = true;
  }; 

  # Дисплей-менеджер и Plasma 6 (бэкап)
 services.displayManager.sddm = {
  enable = true;
  theme = "pixie";
  wayland.enable = true; # Optional: for Wayland sessions

  # Required dependencies for Qt6 themes
  extraPackages = [
    pkgs.kdePackages.qtsvg
    pkgs.kdePackages.qtdeclarative
    pkgs.kdePackages.qt5compat
  ];
};
  services.desktopManager.plasma6.enable = true;

  # Печать и Steam
  services.printing.enable = true;
  programs.steam.enable = true;

  # Звук (Pipewire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Пользователь
  users.users."rites" = {
    isNormalUser = true;
    description = "rites";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Системные пакеты
  environment.systemPackages = with pkgs; [
    # Софт
    discord
    spotify
    telegram-desktop
    prismlauncher
    kitty
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    grim
    slurp
    wl-clipboard
    pavucontrol
    wev    
    yt-dlp
    parabolic
    cliphist
    vlc
    foliate
    btop
    cliphist
    tor-browser
    waypaper
    cloudflare-warp
    pkgs.pipx    
  

    # Окружение Hyprland
    rofi
    mako
    hyprpaper
    quickshell
    matugen
    networkmanagerapplet # Апплет Wi-Fi
    wofi
    qt6.qtdeclarative
    qt6.qtsvg

    # Системные утилиты
    fastfetch
    bottom
    cava
    git
    fish
    asusctl
    inputs.fetch-repo.packages.${pkgs.system}.default

    # Обязательные утилиты для работы кнопок бара (Quickshell)
    wireplumber
    pamixer
    networkmanager
    brightnessctl
    glib
    psmisc
    curl
    jq
    playerctl

    # Темы и шрифты
    adwaita-icon-theme
    hicolor-icon-theme
    noto-fonts
    nerd-fonts.jetbrains-mono
    papirus-icon-theme
    gsettings-desktop-schemas

  # Install and customize the theme. All fields are optional and will
    # fall back to theme defaults if not set.
    (inputs.pixie-sddm.packages.${pkgs.stdenv.hostPlatform.system}.pixie-sddm.override {
      avatar = ./merlin-hermes.jpg;         # Nix path or absolute
      accentColor = "#3F5F91";          # Hex color code
      autoColor = true;                 # true/false
      backgroundColor = "#1A1C1E";      # Hex color code
      textColor = "#E2E2E6";            # Hex color code
      fontFamily = "JetBrains Mono";    # Font family name (must be installed system-wide)
    })

  ];

  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}


