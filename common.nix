{ config, pkgs, ... }:

let
  lib = pkgs.lib;
in
{
  networking.networkmanager.enable = true;

  users.users.rotaerk = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  time.timeZone = "America/New_York";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  security.rtkit.enable = true; # A recommended option to accompany pipewire

  services = {
    logind.extraConfig = ''
      # don't shutdown when power button is pressed
      HandlePowerKey=ignore
    '';

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = false;
    };

    sshd.enable = true;

    # Needed for bashmount to work nicely.
    udisks2.enable = true;

    xserver = {
      enable = true;

      xkb = {
        layout = "us,us";
        variant = "dvorak,";
        options = "ctrl:swapcaps,grp:toggle";
      };

      displayManager.lightdm.enable = true;
      desktopManager.xterm.enable = true;

      # Disables the PS4 controller's touchpad.
      inputClassSections = [
        ''
        Identifier "ds-touchpad"
        Driver "libinput"
        MatchProduct "Wireless Controller Touchpad"
        Option "Ignore" "True"
        ''
      ];
    };
  };

  sound.enable = lib.mkForce false; # disable alsa

  hardware = {
    bluetooth.enable = true;

    pulseaudio.enable = lib.mkForce false;

    graphics = {
      enable = true;
      enable32Bit = true;
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
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;
}
