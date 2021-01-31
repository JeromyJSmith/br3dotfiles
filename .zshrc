#!/usr/bin/env zsh
### Zsh configuration
# usage: ln -fns $(pwd)/.zshrc ~/.zshrc

### initial setup configured by zsh-newuser-install
# To re-run setup: autoload -U zsh-newuser-install; zsh-newuser-install -f
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=50000
setopt autocd extendedglob globdots histignorespace noautomenu nomatch

### keybindings: based on https://github.com/romkatv/zsh4humans
bindkey -e
bindkey -s '^[[1~' '^[[H'
bindkey -s '^[[4~' '^[[F'
bindkey -s '^[[5~' ''
bindkey -s '^[[6~' ''
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^?' backward-delete-char
bindkey '^[[3~' delete-char
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
bindkey '^H' backward-kill-word
bindkey '^[[3;3~' kill-word
bindkey '^N' kill-buffer

### exports
if command -v code-exploration &>/dev/null; then
  export EDITOR='code-exploration --wait'
elif command -v codium &>/dev/null; then
  export EDITOR='codium --wait'
elif command -v code &>/dev/null; then
  export EDITOR='code --wait'
elif command -v code-insiders &>/dev/null; then
  export EDITOR='code-insiders --wait'
else
  export EDITOR='vim'
fi
TTY=$(tty)
export GPG_TTY=$TTY
export PATH=$PATH:$HOME/.local/bin:$HOME/.poetry/bin
export SSH_KEY_PATH=$HOME/.ssh/id_rsa_$USER
if [[ $(uname) = 'Linux' ]]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

### aliases
alias python='python3'

### prompt: https://github.com/sindresorhus/pure
if ! command -v npm &>/dev/null || [[ $(uname) = 'Linux' ]]; then
  [[ -d $HOME/.zsh/pure ]] && fpath+=$HOME/.zsh/pure
fi
autoload -U promptinit
promptinit
prompt pure

### completions
zstyle :compinstall filename $HOME/.zshrc
autoload -Uz compinit
# ignore insecure directories (perms issues for non-admin user)
[[ $(whoami) = 'brendon.smith' ]] && compinit -i || compinit
if type brew &>/dev/null; then
  fpath+=$HOME/.zfunc:$(brew --prefix)/share/zsh-completions
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C $(brew --prefix)/bin/terraform terraform
  . $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  if [[ -d $HOME/.zsh/zsh-syntax-highlighting ]]; then
    . $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi
fi
