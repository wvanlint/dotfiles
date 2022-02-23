export EDITOR='vim'
export FZF_DEFAULT_COMMAND="rg --files --hidden"
export GOPATH="$HOME/go"
export BAT_THEME="zenburn"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Set up PATH with workaround for path_helper.
if [ -x /usr/libexec/path_helper ]; then
  export PATH=""
  eval $(/usr/libexec/path_helper -s)
fi
if [ -f /opt/homebrew/bin/brew ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
fi
typeset -Ux path
path=($path $HOME/bin $GOPATH/bin)
. "$HOME/.cargo/env"

# A local .zshenv outside of version control.
if [ -f "$HOME/.zshenv.local" ]; then
  . "$HOME/.zshenv.local"
fi

export ZSH_ENV_PATH=$PATH
