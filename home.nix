{ config, pkgs, ... }:

{
  home.username = "frank";
  home.homeDirectory = "/home/frank";
  home.stateVersion = "24.11";
  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    tmux
    neovim
    just
    ghostty
  ];

  programs.home-manager.enable = true;
  programs.fish.enable = true;
  programs.starship.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "Frank de Weers";
      user.email = "fdeweers@gmail.com";
      github.user = "Pixel-Polyglot";
      init.defaultBranch = "main";
    };
  };
}
