##=================================================================
## 言語の設定
##=================================================================
export LANG=ja_JP.UTF-8

##=================================================================
## もしoh-my-zshがあればそいつを読み込む
##=================================================================
if [ ! -f ~/.oh-my-zsh/templates/zshrc.zsh-template ]
then
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi
source ~/.oh-my-zsh/templates/zshrc.zsh-template

##=================================================================
## コマンド履歴の設定
##=================================================================
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
alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"
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
export GREP_OPTIONS
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
## 最後にもし自分専用のファイルがあればそいつを読み込む
##=================================================================
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

##=================================================================
## Travisのファイルがあればそいつを読み込む
##=================================================================
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh
