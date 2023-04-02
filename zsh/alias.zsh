# Basic
alias c='clear'
alias vim='$HOME/.local/bin/nvim'
alias svim='sudo vim'
alias vi=vim
alias edit=vim

# Config Dotfiles
alias reload='source ~/.zshrc'
alias rl='reload'
alias zc='vim ~/.zshrc'
alias zac='vim ~/code/dotfiles/zsh/alias.zsh'
alias vc='vim ~/.config/nvim/init.lua'
alias tc='vim ~/.config/tmux/tmux.conf'

# JavaScript & NodeJS
alias pn='pnpm'
alias pni='pnpm install'
alias pnu='pnpm uninstall'
alias pns='pnpm start'
alias pnd='pnpm dev'

# starship prompt
alias ss='starship'
alias ssc='starship config'

# Search using rg
# rg Foo       # Case sensitive search
# rg -i foo    # Case insensitive search
# rg -v foo    # Invert search, show all lines that don't match pattern
# rg -l foo    # List only the files that match, not content
# rg -t md foo # Match by `md` file extension
alias search='rg'
alias s='search'

# Net
alias header='curl -I'

# Git
alias ghc="gh repo clone"
alias gbc="git checkout -b"
alias gst="git status"
alias gd="git diff"
alias gg="git pull"
alias gp="git push"
alias gpf="git push --force"

alias gc="git commit --verbose"
alias gcm="git commit --verbose --message"
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
