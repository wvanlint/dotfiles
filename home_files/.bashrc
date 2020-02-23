# Shopt options
shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dirspell
shopt -s expand_aliases
shopt -s extglob
shopt -s extquote
shopt -s globstar
shopt -s histappend
shopt -s hostcomplete
shopt -s interactive_comments
shopt -s no_empty_cmd_completion
shopt -s progcomp
shopt -s promptvars
shopt -s sourcepath

# History
HISTCONTROL=ignoreboth:erasedups
HISTFILESIZE=10000
HISTSIZE=10000
PROMPT_COMMAND='history -a; history -c; history -r'

# Completion
if [[ -f /usr/local/etc/bash_completion ]]; then
  . /usr/local/etc/bash_completion
elif [[ -f /etc/bash_completion ]]; then
  . /etc/bash_completion
fi

# Colored command-line prompt
PS1='\[\e[32m\]\u \[\e[34m\]\w \[\e[32m\]\$ \[\e[0m\]'

# Aliases
if [[ -f ~/.bash_aliases ]]; then
  . ~/.bash_aliases
fi

# A local .bashrc outside of version control
if [[ -f ~/.bashrc.local ]]; then
  . ~/.bashrc.local
fi

# If the shell is started outside of a tmux session,
# attach to an existing tmux session or start a new one.
if which tmux >/dev/null 2>&1 && [[ -z $TMUX ]]; then
  tmux attach || tmux new-session
fi
