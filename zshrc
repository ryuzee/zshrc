##=================================================================
## 言語の設定
##=================================================================
export LANG=ja_JP.UTF-8

##=================================================================
## 必要なパッケージの導入
##=================================================================
PECO_VERSION="0.3.4"

if [ -f /etc/lsb-release ]
then
  if command -v go > /dev/null; then
    export GOPATH=/usr/share/go
    export PATH=$PATH:$GOPATH
  else
    echo "== Please install Go command =="
    echo "sudo add-apt-repository ppa:evarlast/golang1.4"
    echo "sudo apt-get update"
    echo "sudo apt-get install golang"
  fi

  if command -v peco > /dev/null; then
    ;
  else
    wget https://github.com/peco/peco/releases/download/v${PECO_VERSION}/peco_linux_amd64.tar.gz -O /tmp/peco.tar.gz
    tar xvfz /tmp/peco.tar.gz -C /tmp
    sudo -E mv /tmp/peco_linux_amd64/peco /usr/local/bin/
    sudo -E chmod 755 /usr/local/bin/peco
    rm -rf /tmp/peco_linux_amd64
  fi
fi

if [ -f /usr/bin/sw_vers ]
then
  if command -v go > /dev/null; then
    export GOROOT=/usr/local/opt/go/libexec
    export GOPATH=/opt/go
  else
    echo "== Please install Go command =="
    echo "brew install go"
    sudo -E mkdir -p /opt/go
    brew install go
  fi

  if command -v peco > /dev/null; then
    ;
  else
    wget https://github.com/peco/peco/releases/download/v${PECO_VERSION}/peco_darwin_amd64.zip -O /tmp/peco.zip
    unzip /tmp/peco.zip
    sudo -E mv /tmp/peco_darwin_amd64/peco /usr/local/bin/peco
    sudo -E chmod 755 /usr/local/bin/peco
    rm -rf /tmp/peco_darwin_amd64
  fi
fi

if [ -f ~/.oh-my-zsh/custom/plugins/zsh-completions/README.md ]; then
  ;
else
  git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
fi

##=================================================================
## oh-my-zshの設定
##=================================================================
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git ruby osx bundler brew rails emoji-clock common-aliases zsh-completions)

if [ ! -f $ZSH/oh-my-zsh.sh ]
then
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi
source $ZSH/oh-my-zsh.sh
autoload -U compinit && compinit

##=================================================================
## コマンド履歴の設定
##=================================================================
setopt share_history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

##=================================================================
## cdで移動したらlsする
##=================================================================
function chpwd() { ls -F }

##=================================================================
## my alias
##=================================================================
alias du="du -h"
alias df="df -h"
alias su="su -l"
alias ga="for f in `ls -1`\n do\n echo $f\n done"
if [ -f /etc/lsb-release ]
then
  alias gvim="gvim > /dev/null 2>&1"
fi

##=================================================================
## rbenvの設定
##=================================================================
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"

##=================================================================
## nodebrewの設定
##=================================================================
export PATH=$HOME/.nodebrew/current/bin:$PATH

##=================================================================
## grepの設定
##=================================================================
## デフォルトオプションの設定
## export GREP_OPTIONS
### バイナリファイルにはマッチさせない。
GREP_OPTIONS="--binary-files=without-match"
### grep対象としてディレクトリを指定したらディレクトリ内を再帰的にgrepする。
GREP_OPTIONS="--directories=recurse $GREP_OPTIONS"
### 拡張子が.tmpのファイルは無視する。
GREP_OPTIONS="--exclude=\*.tmp $GREP_OPTIONS"
## 管理用ディレクトリを無視する。
GREP_OPTIONS="--exclude-dir=.svn $GREP_OPTIONS"
GREP_OPTIONS="--exclude-dir=.git $GREP_OPTIONS"
GREP_OPTIONS="--exclude-dir=.deps $GREP_OPTIONS"
GREP_OPTIONS="--exclude-dir=.libs $GREP_OPTIONS"
### 可能なら色を付ける。
GREP_OPTIONS="--color=auto $GREP_OPTIONS"

##=================================================================
## pecoを使ってコマンド履歴をいい感じに選択する
##=================================================================
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history
bindkey '^x' peco-select-history

##=================================================================
## tmux
##=================================================================
# if [ -z "$TMUX" -a -z "$STY" ]; then
    # if type tmuxx >/dev/null 2>&1; then
        # tmuxx
    # elif type tmux >/dev/null 2>&1; then
        # if tmux has-session && tmux list-sessions | egrep -q '.*]$'; then
            # # デタッチ済みセッションが存在する
            # tmux attach && echo "tmux attached session "
        # else
            # tmux new-session && echo "tmux created new session"
        # fi
    # elif type screen >/dev/null 2>&1; then
        # screen -rx || screen -D -RR
    # fi
# fi

##=================================================================
## 最後にもし自分専用のファイルがあればそいつを読み込む
##=================================================================
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

##=================================================================
## Travisのファイルがあればそいつを読み込む
##=================================================================
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh
