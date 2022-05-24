# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "amaethon";
    networkmanager.enable = true;
  };

  users.users.rotaerk = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  time.timeZone = "America/New_York";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services = {
    logind.extraConfig = ''
      # don't shutdown when power button is pressed
      HandlePowerKey=ignore
    '';

    xserver = {
      enable = true;
      layout = "us,us";
      xkbVariant = "dvorak,";
      xkbOptions = "ctrl:swapcaps,grp:ctrl_alt_toggle";

      videoDrivers = ["nvidia"];

      displayManager.lightdm.enable = true;
      desktopManager.xterm.enable = true;
    };

    joycond.enable = true; # For Nintendo Pro Controller...
  };

  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };

    opengl = {
      enable = true;
      driSupport32Bit = true;
    };

    steam-hardware.enable = true;
  };

  environment = {
    variables = {
      EDITOR = "kak";
      VISUAL = "kak";
    };

    systemPackages = with pkgs; [
      git
      kakoune
      pciutils
      w3m
    ];
  };

  programs.steam.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
