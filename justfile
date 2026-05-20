dotfiles := "."

# Switch to current home-manager config
switch:
    home-manager switch --flake "{{dotfiles}}#frank"

# Update flake lock and switch
update:
    nix flake update "{{dotfiles}}"
    home-manager switch --flake "{{dotfiles}}#frank"

# Update flake lock only
update-lock:
    nix flake update "{{dotfiles}}"

# Switch using nix run (works without home-manager in PATH)
switch-nix:
    nix run "github:nix-community/home-manager" -- switch -b backup --flake "{{dotfiles}}#frank"

# Show available commands
default:
    @just --list
