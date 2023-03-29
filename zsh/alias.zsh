# Editor alias
alias vim='$HOME/.local/bin/nvim'
alias svim='sudo vim'
alias vi=vim
alias edit=vim

# Config alias
alias zc='vim ~/.zshrc'
alias vc='vim ~/.config/nvim/init.lua'
alias tc='vim ~/.config/tmux/tmux.conf'
alias s='source ~/.zshrc'
alias c='clear'
alias pn='pnpm'

# Net
alias header='curl -I'

# Tmux
alias tks='tmux kill-server'
alias tn='tmuxinator n'
alias to='tmuxinator o'
alias ts='tmuxinator s'

# Miscs
alias ls='ls --color=auto'
alias la='ls --color=auto -Ah'
alias ll='ls --color=auto -lAh'
alias cpwd='pwd | tr -d "\n" | pbcopy && echo "pwd copied to clipboard"'
alias mkdir='mkdir -pv'

# Shopify
alias theme='shopify theme'
