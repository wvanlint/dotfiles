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
path=($HOME/bin $path $GOPATH/bin $HOME/.local/bin)

if [ -r "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
elif command -v brew >/dev/null 2>&1 &&
     rustup_prefix="$(brew --prefix rustup 2>/dev/null)" &&
     [ -x "$rustup_prefix/bin/rustup" ]; then
  # Homebrew's keg-only rustup needs its bin directory on PATH.
  path=("$rustup_prefix/bin" $path)
fi
unset rustup_prefix

# A local .zshenv outside of version control.
if [ -f "$HOME/.zshenv.local" ]; then
  . "$HOME/.zshenv.local"
fi

export ZSH_ENV_PATH=$PATH
