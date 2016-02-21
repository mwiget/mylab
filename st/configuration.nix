# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sdc";
  boot.kernelParams = [ "default_hugepagesz=1GB" "hugepagesz=1GB" "hugepages=32" "isolcpus=1-3,9-11" ];

  # Docker support
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "devicemapper";
  virtualisation.docker.extraOptions = "--bridge=br0";
  # https://github.com/NixOS/nixpkgs/issues/11478
  virtualisation.docker.socketActivation = true;

  networking.hostName = "st";
  networking.firewall.allowPing = true;
  networking.bridges = {
    br0.interfaces = [ "eno1" ];
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # development tools
    gcc glibc git gnumake wget nmap tmux 
    # editors
    vim
    # Docker
    docker
    # Others
    htop pciutils
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  users.extraUsers.mwiget = {
    isNormalUser = true;
    uid = 1000;
    description = "Marcel Wiget";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3NzaC1kc3MAAACBAMdlCk1NNT2O+np4uzFWFDHP+zTS8uAC6c0mv2miSgAgJxFyfZpJH+HbOuLALCoyPrQbAPb+yPeXvl7xQwAUd94QW3dsX8B70skaxGQMXJdvEu3iDSnpxdeNMW+Ctl4JDHwNoZ93dCxqUqiF5tIE9ock8r1vEZ4d4Xy/LWe+mneVAAAAFQCZ3YEG7uDAfKRxcIK7v4XJyCknCwAAAIA4l8xAexLrEiheg8w8YYGvTtTV20xDaFObLI0fWFpYM0n6g80xkGoM409/1ne6PPqOydCp6dfNcbqf2vCq2WxffjEetMSE5BNk02JctdafO8wiGVFnQd39I+n70SCU/48s/NX+RqWcRgTlwDzp034ZiclDrmrBGVmz5TAJWXT8BgAAAIBbYv/+kxyNdM0HLiQn6/ShTCqK6gkhumDn3a/SS0nHx3LpdlACX9x49a7VTf4tYqctW6LUkE9ei0cvsHWq2ec6Q00UAypCaTtwUjt7vr7HmwuTKV6XOsLkupnEED5jtRgeEz5fuWPIMH6Xg/GENJ5z7N/6AlaOz3Emu6TQtkdwPw==" ];   
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";
  system.autoUpgrade.enable = true;
}
