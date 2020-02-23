# Environment variables.
export EDITOR='vim'
export PATH="$PATH:$HOME/bin:$HOME/npm/bin"

# A local .profile outside of version control
if [ -f $HOME/.profile.local ]; then
  . $HOME/.profile.local
fi
