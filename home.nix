{ config, pkgs, lib, ... }:

{
  home.username = "frank";
  home.homeDirectory = "/home/frank";
  home.stateVersion = "24.11";
  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    zellij
    neovim
    just
    ghostty
    bluespec
    sshfs
    opencode
  ];

  home.sessionVariables = {
    TERMINFO_DIRS = "${pkgs.ghostty.terminfo}/share/terminfo";
  };

  home.activation.updateLazyVim = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d ~/.config/nvim/.git ]; then
      $DRY_RUN_CMD git -C ~/.config/nvim pull
    else
      $DRY_RUN_CMD rm -rf ~/.config/nvim
      $DRY_RUN_CMD git clone https://github.com/LazyVim/starter ~/.config/nvim
    fi
  '';

  xdg.configFile."nvim/lua/plugins/neogit.lua".source = ./nvim/neogit.lua;

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
