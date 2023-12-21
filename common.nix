{ config, pkgs, ... }:

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

  services = {
    logind.extraConfig = ''
      # don't shutdown when power button is pressed
      HandlePowerKey=ignore
    '';

    sshd.enable = true;

    # Needed for bashmount to work nicely.
    udisks2.enable = true;

    xserver = {
      enable = true;
      layout = "us,us";
      xkbVariant = "dvorak,";
      xkbOptions = "ctrl:swapcaps,grp:toggle";

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

  hardware = {
    bluetooth.enable = true;

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
}
