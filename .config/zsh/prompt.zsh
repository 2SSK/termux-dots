#!/usr/bin/env zsh

autoload -U colors
colors

setopt PROMPT_SUBST

# =======================
# Git branch + status
# =======================
parse_git_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null || return
}

git_status_symbol() {
  git rev-parse --git-dir >/dev/null 2>&1 || return

  if [[ -z "$(git status --porcelain 2>/dev/null)" ]]; then
    echo "✓"
  else
    echo "✗"
  fi
}

# =======================
# Battery status
# =======================
battery_status() {
  local bat="/sys/class/power_supply/BAT0"
  [[ -d "/sys/class/power_supply/BAT1" ]] && bat="/sys/class/power_supply/BAT1"

  if [[ -d "$bat" ]]; then
    local cap=$(cat "$bat/capacity")
    echo "⚡${cap}%"
  fi
}

# =======================
# SSH indicator
# =======================
if [[ -n "$SSH_CLIENT" ]]; then
  SSH_MSG="%F{red}-ssh%f"
else
  SSH_MSG=""
fi

# =======================
# Prompt
# =======================
PROMPT='%F{green}%n'"$SSH_MSG"' %F{white}at %F{yellow}%m %F{white}in %F{blue}%~%F{cyan} $(parse_git_branch) $(git_status_symbol)
%F{magenta}$(battery_status) %F{cyan}$ %f'

