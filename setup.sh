#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
USERNAME="frank"

info()  { echo -e "\033[0;32m[INFO]\033[0m $*"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m $*"; }

# 1. Update pacman
info "Updating pacman..."
sudo pacman -Syu

# 2. Install nix
if ! command -v nix &>/dev/null; then
    info "Installing nix..."
    sudo pacman -S --noconfirm nix
    sudo systemctl enable --now nix-daemon
    sudo usermod -aG nix-users "$USERNAME"
fi

. /etc/profile.d/nix.sh 2>/dev/null || true
. /etc/profile.d/nix-daemon.sh 2>/dev/null || true

# 3. Enable flakes
info "Enabling flakes..."
sudo mkdir -p /etc/nix
if ! grep -q "experimental-features" /etc/nix/nix.conf 2>/dev/null; then
    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
fi
sudo systemctl restart nix-daemon 2>/dev/null || true

# 4. Re-exec with nix-users group if the current session lacks it
if ! groups | grep -q nix-users 2>/dev/null; then
    if command -v sg &>/dev/null; then
        info "Re-executing with nix-users group..."
        exec sg nix-users -c "$0"
    else
        warn "nix-users group not active. Log out/in and re-run this script."
        exit 1
    fi
fi

# 5. Apply home-manager config via flakes
info "Applying home-manager config..."
nix run "github:nix-community/home-manager" -- switch --flake "${DOTFILES}#frank"

# 6. LazyVim template
if [ -d ~/.config/nvim/.git ]; then
    info "Updating LazyVim starter..."
    git -C ~/.config/nvim pull
else
    info "Fetching LazyVim starter..."
    rm -rf ~/.config/nvim
    git clone https://github.com/LazyVim/starter ~/.config/nvim
fi

# 7. Fish as default shell
FISH="$(command -v fish 2>/dev/null || true)"
if [ -n "$FISH" ] && [ "$(basename "$SHELL")" != "fish" ]; then
    grep -q "$FISH" /etc/shells 2>/dev/null || echo "$FISH" | sudo tee -a /etc/shells
    sudo chsh -s "$FISH" "$USERNAME"
    info "Default shell set to fish"
fi

echo ""
info "Done. Log out and back in to start using fish."
