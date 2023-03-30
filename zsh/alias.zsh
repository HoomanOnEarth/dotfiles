# Editor alias
alias vim='$HOME/.local/bin/nvim'
alias svim='sudo vim'
alias vi=vim
alias edit=vim

# Config alias
alias zc='vim ~/.zshrc'
alias zac='vim ~/code/dotfiles/zsh/alias.zsh'
alias vc='vim ~/.config/nvim/init.lua'
alias tc='vim ~/.config/tmux/tmux.conf'
alias ssc='starship config'
alias s='source ~/.zshrc'
alias c='clear'
alias pn='pnpm'

# Net
alias header='curl -I'

# Git
alias ghc="gh repo clone"
alias gst="git status --verbose"
alias gd="git diff"
alias gg="git pull"
alias gp="git push"
alias gpf="git push --force"

alias gc="git commit --verbose"
alias gca="git commit --all --verbose"
alias gcam="git commit --amend --verbose"
alias gcam!="git commit --amend --no-edit"

alias ga="git add --verbose"
alias gaa="git add --all --verbose"
alias gau="git add --update --verbose"

alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glp="gl -p"

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
