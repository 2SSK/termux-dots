#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
BIN_DIR="$DOTFILES/bin"
PREFIX_BIN="$PREFIX/bin"

source "$DOTFILES/tux/core/utils.sh"

log "🚀 Starting tux bootstrap..."

# ================================
# Detect OS
# ================================
if [[ -n "$TERMUX_VERSION" ]]; then
  OS="termux"
else
  OS="linux"
fi

log "Detected OS: $OS"

# ================================
# Base packages
# ================================
install_base() {
  log "Installing base packages..."

  if [[ "$OS" == "termux" ]]; then
    pkg update -y
    pkg install -y git curl wget stow proot-distro
  else
    sudo apt update -y
    sudo apt install -y git curl wget stow build-essential
  fi
}

# ================================
# Core dev packages
# ================================
install_packages() {
  log "Installing dev packages..."

  if [[ "$OS" == "termux" ]]; then
    pkg install -y \
      zsh neovim bat fzf ripgrep tmux nodejs yarn clang golang \
      eza zoxide fastfetch lazygit yazi
  else
    sudo apt install -y \
      zsh neovim bat fzf ripgrep tmux nodejs yarn clang golang \
      eza zoxide fastfetch lazygit yazi
  fi
}

# ================================
# Install Docker (Termux way)
# ================================
install_docker() {
  log "Installing Docker..."

  if [[ "$OS" == "termux" ]]; then
    pkg install -y docker
    warn "⚠ Docker in Termux requires proot or rootless setup"
  else
    curl -fsSL https://get.docker.com | sh
  fi
}

# ================================
# Install Arch Linux (proot-distro)
# ================================
install_arch() {
  if [[ "$OS" == "termux" ]]; then
    log "Installing Arch Linux via proot-distro..."
    proot-distro install archlinux || true
  fi
}

# ================================
# Zsh plugins
# ================================
install_zsh_plugins() {
  log "Installing Zsh plugins..."

  ZSH_DIR="$HOME/.zsh"
  mkdir -p "$ZSH_DIR"

  clone() {
    local repo="$1"
    local dir="$2"
    [[ -d "$dir" ]] || git clone "$repo" "$dir"
  }

  clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_DIR/zsh-syntax-highlighting"
  clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_DIR/zsh-autosuggestions"
  clone https://github.com/zsh-users/zsh-completions "$ZSH_DIR/zsh-completions"
}

# ================================
# tmux TPM
# ================================
install_tpm() {
  log "Installing tmux TPM..."

  TPM="$HOME/.tmux/plugins/tpm"
  [[ -d "$TPM" ]] || git clone https://github.com/tmux-plugins/tpm "$TPM"
}

# ================================
# Symlink tux CLI
# ================================
install_tux() {
  log "Linking tux CLI..."

  chmod +x "$BIN_DIR/tux"
  ln -sf "$BIN_DIR/tux" "$PREFIX_BIN/tux"

  log "tux installed → $PREFIX_BIN/tux"
}

# ================================
# Stow dotfiles
# ================================
stow_dotfiles() {
  log "Stowing dotfiles..."

  cd "$DOTFILES"

  stow zsh || true
  stow nvim || true
  stow tmux || true
  stow git || true

  log "Dotfiles linked ✅"
}

# ================================
# Set default shell
# ================================
set_shell() {
  if command -v zsh >/dev/null; then
    log "Setting zsh as default shell..."
    chsh -s "$(which zsh)" || true
  fi
}

# ================================
# Run everything
# ================================
install_base
install_packages
install_docker
install_arch
install_zsh_plugins
install_tpm
install_tux
stow_dotfiles
set_shell

log "🎉 tux bootstrap completed!"
echo "👉 Restart Termux or run: zsh"

