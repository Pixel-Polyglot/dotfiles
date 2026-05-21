{ config, pkgs, lib, ... }:

{
  home.username = "frank";
  home.homeDirectory = "/home/frank";
  home.stateVersion = "24.11";
  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    neovim
    just
    ghostty
    bluespec
    sshfs
    opencode
    github-cli
    fastfetch
  ];

  home.sessionVariables = {
    TERMINFO_DIRS = "${pkgs.ghostty.terminfo}/share/terminfo";
    COLORTERM = "truecolor";
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
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
      fastfetch
      if set -q SSH_CONNECTION; and not set -q ZELLIJ
        zellij attach -c 2>/dev/null; and kill $fish_pid
      end
    '';
  };
  programs.zellij = {
    enable = true;
    settings = {
      pane_frames = false;
      show_startup_tips = false;
    };
  };
  programs.starship.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "Frank de Weers";
      user.email = "fdeweers@gmail.com";
      github.user = "Pixel-Polyglot";
      init.defaultBranch = "main";
      credential.helper = ["!gh auth git-credential"];
    };
  };
}
