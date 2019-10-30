
# Path to your oh-my-zsh installation.
export ZSH="/Users/myles/.oh-my-zsh"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
source ~/.creds/niagara
alias dc='docker-compose'

ZSH_THEME=powerlevel10k/powerlevel10k


CASE_SENSITIVE="true"

HYPHEN_INSENSITIVE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"


# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zshmarks)

source $ZSH/oh-my-zsh.sh

# Kubernetes
alias k='kubectl'
alias kx='kubectx'
alias kns='kubens'

# Navigation
alias j='jump'
alias b='bookmark'

alias sauce='source ~/.zshrc'
alias esauce='vim ~/.zshrc'

watch() {
  time=$1
  shift
  while true; do 
    clear
    eval $@
    sleep $time 
  done
}

extract() {
  while read data; do
    echo $data | grep -Eo "$1=.+\w" | awk -F'=' '{print $2}' | awk '{print $1}'
  done
}

avg() {
    d=""
    while read data; do
      d="$d\n$data"
    done 
    echo $d | awk '{ total += $1; count++ } END { print total/count }'
}

niagara-pod() {
  kubectl get pods -n default -o json | grep '"name":' | grep -Eo 'niagara-[A-z0-9]+-[A-z0-9]+' 
}

nlogs() {
  kubectl logs -n default $(niagara-pod) $@
}


# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
alias config='/usr/bin/git --git-dir=/Users/myles/.cfg/ --work-tree=/Users/myles'
