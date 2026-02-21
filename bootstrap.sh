#!/bin/bash

# Dotfiles Bootstrap Script
# Idempotent setup for Arch Linux ARM

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Arch Linux
check_arch() {
    if [[ ! -f /etc/os-release ]]; then
        print_error "Cannot determine OS"
        exit 1
    fi
    
    if ! grep -q "ID=arch" /etc/os-release && ! grep -q "ID=archarm" /etc/os-release; then
        print_error "This script is designed for Arch Linux"
        exit 1
    fi
    
    print_success "Arch Linux detected"
}

# Update package database
update_pacman() {
    print_info "Updating package database..."
    if sudo pacman -Sy; then
        print_success "Package database updated"
    else
        print_error "Failed to update package database"
        exit 1
    fi
}

# Install packages
install_packages() {
    print_info "Installing packages..."
    
    local packages=(
        # Core
        zsh git tmux neovim stow curl wget base-devel
        # Tools
        fzf zoxide bat eza ripgrep fastfetch btop yazi lazygit lazydocker
        # Development
        nodejs yarn go
        # Clipboard
        xclip wl-clipboard
    )
    
    for pkg in "${packages[@]}"; do
        if pacman -Qi "$pkg" &>/dev/null; then
            print_info "$pkg already installed, skipping"
        else
            print_info "Installing $pkg..."
            sudo pacman -S --noconfirm --needed "$pkg"
        fi
    done
    
    print_success "Package installation complete"
}

# Install yay (AUR helper)
install_yay() {
    if command -v yay &>/dev/null; then
        print_success "yay already installed"
        return
    fi
    
    print_info "Installing yay (AUR helper)..."
    
    # Create temporary directory
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    # Clone and build yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    
    # Cleanup
    cd "$SCRIPT_DIR"
    rm -rf "$temp_dir"
    
    print_success "yay installed"
}

# Remove Oh-My-Zsh if exists
remove_ohmyzsh() {
    local omz_dir="$HOME/.oh-my-zsh"
    
    if [[ -d "$omz_dir" ]]; then
        print_warning "Removing existing Oh-My-Zsh installation..."
        rm -rf "$omz_dir"
        
        # Also remove from .zshrc if backup exists
        if [[ -f "$HOME/.zshrc.pre-oh-my-zsh" ]]; then
            rm "$HOME/.zshrc.pre-oh-my-zsh"
        fi
        
        print_success "Oh-My-Zsh removed"
    else
        print_info "Oh-My-Zsh not found, skipping removal"
    fi
}

# Install zsh plugins
install_zsh_plugins() {
    print_info "Installing zsh plugins..."
    
    local plugins_dir="$HOME/.config/zsh/plugins"
    mkdir -p "$plugins_dir"
    
    # zsh-autosuggestions
    local autosuggestions_dir="$plugins_dir/zsh-autosuggestions"
    if [[ -d "$autosuggestions_dir" ]]; then
        print_info "zsh-autosuggestions already installed"
    else
        print_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$autosuggestions_dir"
        print_success "zsh-autosuggestions installed"
    fi
    
    # zsh-syntax-highlighting
    local syntax_dir="$plugins_dir/zsh-syntax-highlighting"
    if [[ -d "$syntax_dir" ]]; then
        print_info "zsh-syntax-highlighting already installed"
    else
        print_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$syntax_dir"
        print_success "zsh-syntax-highlighting installed"
    fi
}

# Install TPM (Tmux Plugin Manager)
install_tpm() {
    print_info "Installing TPM (Tmux Plugin Manager)..."
    
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [[ -d "$tpm_dir" ]]; then
        print_info "TPM already installed"
    else
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
        print_success "TPM installed to $tpm_dir"
        print_info "To install tmux plugins, start tmux and press 'prefix + I'"
    fi
}

# Stow dotfiles
stow_dotfiles() {
    print_info "Stowing dotfiles..."
    
    cd "$SCRIPT_DIR"
    
    # Check if already stowed
    if [[ -L "$HOME/.zshrc" ]] && [[ "$(readlink "$HOME/.zshrc")" == "$SCRIPT_DIR/.zshrc" ]]; then
        print_info "Dotfiles already stowed"
    else
        stow -v .
        print_success "Dotfiles stowed"
    fi
}

# Change default shell to zsh
set_zsh_default() {
    if [[ "$SHELL" == *"zsh"* ]]; then
        print_info "Zsh is already the default shell"
    else
        print_info "Changing default shell to zsh..."
        chsh -s $(which zsh)
        print_success "Default shell changed to zsh (logout and login to apply)"
    fi
}

# Main execution
main() {
    echo -e "${GREEN}=== Dotfiles Bootstrap Script ===${NC}"
    echo ""
    
    check_arch
    update_pacman
    install_packages
    install_yay
    remove_ohmyzsh
    install_zsh_plugins
    install_tpm
    stow_dotfiles
    set_zsh_default
    
    echo ""
    print_success "Bootstrap complete!"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Start a new zsh session or run: source ~/.zshrc"
    echo "2. Open tmux and press 'prefix + I' to install tmux plugins"
    echo "3. Open nvim and wait for Lazy.nvim to install plugins"
}

# Run main if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
