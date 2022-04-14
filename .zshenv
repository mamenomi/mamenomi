
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
# PATHを通す
export PATH="/usr/local/bin:$PATH"

# Beep音をなくす
setopt no_beep

# Ctrl+Dでログアウトしてしまうことを防ぐ
setopt IGNOREEOF

# 日本語を使用
export LANG=ja_JP.UTF-8

# 色を使用
autoload -Uz colors
colors

# 補完
autoload -Uz compinit
compinit

# 他のターミナルとヒストリーを共有
setopt share_history

# ヒストリーに重複を表示しない
setopt histignorealldups

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# コマンドミスを修正
setopt correct
# 補完後、メニュー選択モードになり左右キーで移動が出来る
zstyle ':completion:*:default' menu select=2

# 補完で大文字にもマッチ
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# alias
alias lst='ls -ltr'
alias l='ls -ltr'
alias la='ls -a'
alias ll='ls -l'
alias vi='vim'
alias vz='vim ~/.zshenv'
alias vv='vim ~/.vimrc'
alias c='clear'
alias sz='source ~/.zshenv'
alias sv='source ~/.vimrc'
alias mkdir='mkdir -p'
alias rm='rm -i'
alias ..='cd ..'
alias pip='pip3'
alias py='python3'

function tex() {
    platex $1.tex &&
    dvipdfmx -p $2 $1.dvi &&
    open $1.pdf &&
}

function pycheck() {
    pycodestyle --show-source --show-pep8 $1;
    pydocstyle --ignore=D100,D203,D212 perceptron.py $1;
}
