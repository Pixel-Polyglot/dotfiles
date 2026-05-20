{ config, pkgs, ... }:

{
  home.username = "frank";
  home.homeDirectory = "/home/frank";
  home.stateVersion = "24.11";
  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    tmux
    neovim
    openssh
  ];

  programs.home-manager.enable = true;
  programs.fish.enable = true;
  programs.starship.enable = true;

  programs.git = {
    enable = true;
    userName = "Frank de Weers";
    userEmail = "fdeweers@gmail.com";
    extraConfig = {
      github.user = "Pixel-Polyglot";
      init.defaultBranch = "main";
    };
  };
}
