# Plugin configuration

# ==============================
# Zsh Plugins (without Oh My Zsh)
# ==============================

# Plugin directory
ZSH_PLUGINS_DIR="${ZSH_CONFIG_DIR}/plugins"

# Load zsh-autosuggestions
if [[ -d "${ZSH_PLUGINS_DIR}/zsh-autosuggestions" ]]; then
  source "${ZSH_PLUGINS_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Load zsh-syntax-highlighting (must be last)
if [[ -d "${ZSH_PLUGINS_DIR}/zsh-syntax-highlighting" ]]; then
  source "${ZSH_PLUGINS_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ==============================
# Plugin Settings
# ==============================

# Autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#c99e84'

