# Completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
autoload -Uz compinit
compinit

# Nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Options
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt no_beep
setopt prompt_subst
setopt share_history

unset zle_bracketed_paste

# History
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

# Keybindings
bindkey -v
bindkey -vrp '^['
bindkey -v '^?' backward-delete-char

fzf-history-widget() {
  local selected=$(fc -rln 1 | fzf --query=$BUFFER --height=30% --reverse --tiebreak=index)
  BUFFER=$selected
  zle reset-prompt
  zle end-of-line
  zle vi-insert
  return $ret
}
fzf-widget() {
  local selected=$(fzf -m --height=30% --reverse </dev/tty | xargs echo)
  BUFFER="$BUFFER$selected"
  zle reset-prompt
  zle end-of-line
  zle vi-insert
  return $ret
}
zle -N fzf-history-widget
zle -N fzf-widget
bindkey -a '/' fzf-history-widget
bindkey -a ' p' fzf-widget

# Prompt
# echo -e "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
precmd() {
  precmd() {
    echo
  }
}

autoload -U colors && colors

custom_git_ps1 () {
  local git_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null) has_git="$?"
  if [[ $has_git == 0 ]]; then
    echo -e "%{%f%} on %{%F{green}%} ${git_branch}%{%f%}"
  else
    echo ""
  fi
}
PROMPT=$'%{%F{blue}%}%~$(custom_git_ps1)\n%{%F{green}%}›%{%f%} '

# Aliases
if [[ -f ~/.aliases ]]; then
  . ~/.aliases
fi

# A local .rc outside of version control
if [[ -f ~/.zshrc.local ]]; then
  . ~/.zshrc.local
fi

# If the shell is started outside of a tmux session,
# attach to an existing tmux session or start a new one.
if which tmux >/dev/null 2>&1 && [[ -z $TMUX ]]; then
  tmux attach || tmux new-session
fi
