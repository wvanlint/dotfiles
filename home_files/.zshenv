export EDITOR='vim'
export FZF_DEFAULT_COMMAND="rg --files --hidden"
export PATH="$PATH:$HOME/bin:$HOME/npm/bin"
export BAT_THEME="zenburn"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# A local .zshenv outside of version control
if [ -f $HOME/.zshenv.local ]; then
  . $HOME/.zshenv.local
fi
