
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/binutils/bin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
source ~/.creds/niagara
alias vi=nvim
alias vim=nvim
alias dc='docker-compose'
alias pip=pip3
alias python=python3
alias gs=gsutil
# Used to make adding stuff to my dotfiles repo easier. Stolen from: https://medium.com/@augusteo/simplest-way-to-sync-dotfiles-and-config-using-git-14051af8703a
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

ZSH_THEME=powerlevel10k/powerlevel10k


CASE_SENSITIVE="true"

HYPHEN_INSENSITIVE="true"

plugins=(git zsh-syntax-highlighting zshmarks)

source $ZSH/oh-my-zsh.sh

# Kubernetes
alias k='kubectl'
alias kx='kubectx'
alias kns='kubens'

# Navigation
alias j='jump'
alias b='bookmark && load-bookmarks'

# Make it way easier to edit and load this file. `esauce && sauce`
alias sauce='source ~/.zshrc'
alias esauce='vim ~/.zshrc'

# Extracts data from log files that follow the convention of `level=info message="the message" some_field=some_value`
# For example: 
#     echo "level=info message="finished doing something" duration_ms=12" | extract duration_ms 
# would print "12". Used nicely in conjunction with kubectl logs <pod_name> | grep 'some search term' | extract some_field
extract() {
  while read data; do
    echo $data | grep -Eo "$1=\"?.+\"?" | awk -F'=' '{print $2}' | sed -e 's/\(.*\) .*$/\1/g' -e 's/"//g'  
  done
}

load-bookmarks() {
  while read data; do
    export $(echo $data | awk -F'|' '{print $2}')=$(echo $data | awk -F'|' '{print $1}' | sed -e $(printf 's\$HOME\%s\' "$HOME"))
  done < $HOME/.bookmarks
}
# Call the function during startup
#load-bookmarks

export SECRET_TO_ENV='{{ range $key, $value := .data }}{{printf "%s=%s\n" $key  ($value | base64decode) }}{{ end }}'

# Takes the average of the input strings, delimited by newlines. Used nicely in conjunction with `extract` above for adhoc analysis on logs 
avg() {
    d=""
    while read data; do
      d="$d\n$data"
    done 
    echo $d | awk '{ total += $1; count++ } END { print total/count }'
}

# Finds the niagara pod
niagara-pod() {
  kubectl get pods -n default -o json | grep '"name":' | grep -Eo 'niagara-[A-z0-9]+-[A-z0-9]+' 
}

# prints out the logs for niagara
nlogs() {
  kubectl logs -n default $(niagara-pod) $@
}

thermos() {
  psql -h "$THERMOS_HOST" -U "$THERMOS_USER" -d "$THERMOS_DB"
}

property() {
  psql -h "$PROPERTY_HOST" -U postgres
}


source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
