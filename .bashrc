### If bash does not exist, return
[ "$BASH" = "" ] &&  return
if [ -z "$PS1" ]; then
    return
fi

### source system wide aliases
if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi

### hostname (long style
if [ `uname` != "FreeBSD" ] ; then
  cmd_hostname="hostname -f"
else
  cmd_hostname="hostname"
fi

stty sane
stty -ixon -ixoff # ctrl+s, ctrl+qの無効化
if [ `uname` != 'Darwin' ] && [ "`stty | grep erase`" = "" ] ; then
    stty erase 
fi
tabs -2 # tab width

### completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
if [ -f `brew --prefix`/etc/bash_completion.d/rails.bash ]; then
  source `brew --prefix`/etc/bash_completion.d/rails.bash
fi

### language
if [ `uname` = "FreeBSD" ] ; then
  export LANG=ja_JP.SJIS
  export LC_ALL=ja_JP.SJIS
else
  # ubuntu/centos
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
fi

### internet access
__is_interface_active() {
  is=`ifconfig -u $1 | grep "status: active"`
  if [ -n "$is" ] ; then
    return 0 # possible to access internet
  else
    return 1 # impossible to access internet
  fi
}
__is_net() {
  while [ -n "$1" ]
  do
    __is_interface_active $intf
    if [ "$?" -eq 0 ] ; then
      return 0 # possible
    fi
    shift
  done
  return 1 # impossible
}
if [ `$cmd_hostname` = 'quark.local' ] ; then
  echo "checking to access to internet..."
  __is_net 'en0' 'bridge 0'
  export IS_INTERNET_ACTIVE=$?
  if [ $IS_INTERNET_ACTIVE -eq 0 ] ; then
    echo ">> possible to access to internet!!"
  else
    echo ">> impossible to access to internet :("
  fi
else
  export IS_INTERNET_ACTIVE=0 # possible to access internet in SERVER
fi

### alias
alias ls='ls -G'
alias ll='ls -hlF'
alias la='ls -aF'
alias l='ls -CF'
alias li='ls -1F'
alias his='history'
alias where='which'
alias mkdri='mkdir'
alias sl='ls'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias v='vi'
alias gpp='g++'
alias RM='rm -f'
alias rm='rm -i'
alias CP='cp -f'
alias cp='cp -i'
alias today='date'
export DATE=`date +%Y%m%d`
alias update_date='export DATE=`date +%Y%m%d`' # year month day
alias update_time='export TIME=`date +%s`'
alias bash_keybind="bind -p | grep 'C-' | grep -v 'abort\|version\|accept' | less"
alias ducks='du -h -d 1'
if [ `uname` == 'Linux' ] && [ -x `which xdg-open` ] ; then
  alias open='xdg-open'
  # else if 'Darwin': `open` is supported in default
  # else if 'FreeBSD': NOT supported
fi
if [ -x `which tmux` ] ; then
  alias tmux='tmux -2'
  alias ta='tmux a'
  alias tat='tmux a -t'
fi
if [ -x `which screen` ] ; then
  alias scr='screen -D -RR'
fi

### source
# source ${HOME}/tmp/bash/fpath.sh ## get full path func
# source ${HOME}/tmp/bash/prand.sh ## print random charactors
# source ${HOME}/tmp/bash/makeMakefile.sh ## create template files for c lang
# source ${HOME}/tmp/kancolle/utils/kancolle_logbook.sh ## kancolle logbook

### go lang
# macOS
[ -f /usr/local/opt/go/libexec ] && \
  export GOROOT=/usr/local/opt/go/libexec # go lang bin dir
# linux
[ -f $HOME/.go/versions/1.6 ] && \
  export GOROOT=$HOME/.go/versions/1.6
[ -f $HOME/tmp/go ] && export GOPATH=$HOME/tmp/go # workspace dir
[ -n $GOPATH ] && export PATH=$GOPATH/bin:$PATH

### path
[ -f $HOME/.bin ] && export PATH=$HOME/.bin:$PATH
[ -f /usr/local/texlive/2015/bin/x86_64-darwin ] && \
  export PATH=/usr/local/texlive/2015/bin/x86_64-darwin:$PATH
[ -f /usr/local/wine/bin ] && \
  export PATH=/usr/local/wine/bin:$PATH
[ -f $HOME/tmp/utils/bin ] && \
  export PATH=$HOME/tmp/utils/bin:$PATH
[ -f $HOME/tmp/kancolle/utils/macosx-x64-ex.2.3.4 ] && \
  export PATH=$HOME/tmp/kancolle/utils/macosx-x64-ex.2.3.4:$PATH

###  Completion
# complete -W "vim study php html cake" cake # cakeの補完設定
[ -x `which autoextract` ] && complete -d autoextract # ~/bin/autoextracの補完

###  Environments
export EDITOR=vi ; [ -x `which vim` ] && export EDITOR=vim
export PAGER='less'
export SVN_SSH='ssh -q'
export DAY=`date +%d` # month day
export MONTH=`date +%B` # month in literal
export YEAR=`date +%Y` # year
export MEMO_PATH=${HOME}/Copy/Documents/.memo
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8 # non error for perl
# export PAGER="col -b -x | vim -"
# export XMODIFIERS=@im=uim
# export GTK_IM_MODULE=uim

### console style
if [ `uname` = 'Darwin' ] ; then
  export PS1='\u@\h:\W 〆 '
  export PROMPT_COMMAND='share_history'
elif [ "`echo $TERM | grep 'screen'`" != "" ]; then
  ## Current command name as window name
  #export PS1='\[\033k\033\\\][\u@\h \W]\$ '
  #export PS1='\[\033k\033\\\]\u@\h:\W\$ '
  ## PWD as window name
  #export PS1='\u@\h:\W\$ '
  #export PROMPT_COMMAND='echo -ne "\033k$(basename $(pwd))\033\\"'
  ## PWD when no command is running, otherwise current command name as window name
  #export PS1='\u@\h:\W\$ '
  #export PROMPT_COMMAND='echo -ne "\033k\033\0134\033k$(basename $(pwd))\033\\"'
  ## Above with a shared history among all terminals
  export PS1='\u@\h:\W\$ '
  export PROMPT_COMMAND='echo -ne "\033k\033\0134\033k$(basename $(pwd))\033\\";share_history'
else
  export PS1='\u@\h:\W\$ '
  ## With a shared history among all terminals
  export PROMPT_COMMAND='share_history'
fi

update_date
update_time

###  shopt
# shopt -s cdspell
# shopt -s extglob
# shopt -s histreedit
# shopt -s no_empty_cmd_completion


### shell history
share_history() {
  history -a
  history -c
  history -r
  update_time
}
export HISTCONTROL=ignoreboth
export HISTCONTROL=ignoredups
export HISTIGNORE="cd*:pwd*:fg*:bg*"
export HISTSIZE=10000
shopt -u histappend

### ls color
if [ `uname` = "Linux" ]; then
    alias ls='ls -NF --show-control-chars'
    # if you use color ls, comment out above line and uncomment below 2 lines.
    LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.i386.rpm=01;31:*.src.rpm=01;30:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.png=01;35:' ; export LS_COLORS
    alias ls='ls --color=auto -NF --show-control-chars'
elif [ `uname` = 'FreeBSD' ]; then
    export LSCOLORS=gxfxcxdxbxegedabagacad
    alias ls='ls -G'
fi

### rbenv
export RUBYGEMS_GEMDEPS=
if [ -f $HOME/.rbenv ] ; then
  export PATH=$PATH:$HOME/.rbenv
fi
if [ -x `which rbenv` ] ; then
  eval "$(rbenv init -)"
fi

### user commands (ubuntu
[ `uname` = "Linux" ] && [ -d $HOME/.usr/bin ] && \
  export PATH=$HOME/.usr/bin:$PATH
[ `uname` = "FreeBSD" ] && [ -d $HOME/usr/bin ] && \
  export PATH=$HOME/usr/bin:$PATH
[ `uname` = "Linux" ] && [ -d $HOME/bin/centos ] && \
  export PATH=$HOME/bin/centos

### machine specific .bashrc
if [ -f .`hostname`/dot.bashrc.bash ] ; then
    source .`hostname`/dot.bashrc.bash
fi

### ssh-agent
if [ `$cmd_hostname` = 'quark.local' ] ; then
  # Refs: http://qiita.com/isaoshimizu/items/84ac5a0b1d42b9d355cf
  # eval $(ssh-agent)
  SSH_IDENTIFY_FILE="$HOME/.ssh/hisakazu_quark"
  [ -z "`ssh-add -l | grep $SSH_IDENTIFY_FILE`" ] && \
    ssh-add $SSH_IDENTIFY_FILE
fi
if [ `uname` != 'Darwin' ] ; then
  SSH_AGENT_FILE="${HOME}/.ssh/.ssh-agent.`hostname`"
  if [ -f ${SSH_AGENT_FILE} ]; then
      eval `cat ${SSH_AGENT_FILE}`
      ssh_agent_exist=0
      for id in `ps ax|grep 'ssh-agent'|sed -e 's/\([0-9]\+\).*/\1/'`
      do
          if [ ${SSH_AGENT_PID} = ${id} ]
          then
              ssh_agent_exist=1
          fi
      done
      if [ $ssh_agent_exist = 0 ]
      then
          rm -f ${SSH_AGENT_FILE}
          ssh-agent > ${SSH_AGENT_FILE}
          chmod 600 ${SSH_AGENT_FILE}
          eval `cat ${SSH_AGENT_FILE}`
          ssh-add ${SSH_IDENTITY_FILE}
      fi
  else
      ssh-agent > ${SSH_AGENT_FILE}
      chmod 600 ${SSH_AGENT_FILE}
      eval `cat ${SSH_AGENT_FILE}`
      ssh-add ${SSH_IDENTITY_FILE}
  fi
  alias sshkey='eval `cat ${SSH_AGENT_FILE}`'
  alias sshrm='rm -f ${SSH_AGENT_FILE}'
fi

### hub
if [ -x `which hub` ] ; then
  eval "$(hub alias -s)"
fi

### nvm (Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

### key
# ssh-add ~/.ssh/hisakazu_quark_bitbucket

### docker
# eval $(docker-machine env default)

### kancolle logbook (check wheather process is running
if [ `$cmd_hostname` = 'quark.local' ] ; then
  logbook_pid=`ps aux| grep "logbook" | grep -v "grep" | awk '{ print $2; }'`
  if [ -z $logbook_pid ]; then
    echo "Kancolle Logbook is not started..."
  else
    echo "Kancolle Logbook is already run!"
  fi
fi

# java
[ -n "`/usr/libexec/java_home`" ] && \
  export JAVA_HOME="`/usr/libexec/java_home`"

### pyenv
if [ `$cmd_hostname` = "cad110.naist.jp" ] ||
   [ `$cmd_hostname` = "cad111.naist.jp" ] ||
   [ `$cmd_hostname` = "cad112.naist.jp" ] ||
   [ `$cmd_hostname` = "cad113.naist.jp" ] ||
   [ `$cmd_hostname` = "cad114.naist.jp" ] ||
   [ `$cmd_hostname` = "cad115.naist.jp" ] ||
   [ `$cmd_hostname` = "cad116.naist.jp" ] ||
   [ `$cmd_hostname` = "cad117.naist.jp" ] ||
   [ `$cmd_hostname` = "cad118.naist.jp" ] ; then
  export PYENV_ROOT=$HOME/.pyenv/s1 # pyenv setting #1
elif [ `$cmd_hostname` = 'quark.local' ] ; then
  export PYENV_ROOT=$HOME/.pyenv
fi
if [ -n $PYENV_ROOT ] ; then
  echo "##############################"
  echo "## pyenv #####################"
  echo "PYENV_ROOT: $PYENV_ROOT"
  export PATH=$PYENV_ROOT/bin:$PATH
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  pyenv rehash
fi

### LD_LIBRARY_PATH
[ -z $LD_LIBRARY_PATH ] && \
  export LD_LIBRARY_PATH="" # reset

### cuda
if [ -d /usr/local/cuda ] ; then
  echo "##############################"
  echo "## cuda ######################"
  export CUDA_PATH="/usr/local/cuda"
  export PATH="$CUDA_PATH/bin:$PATH"
  export CFLAGS="-I$CUDA_PATH/include"
  export LDFLAGS="-L$CUDA_PATH/lib64"
  export LD_LIBRARY_PATH="$CUDA_PATH/lib64:$LD_LIBRARY_PATH"
  nvcc -V
  if [ -f $CUDA_PATH/include/cudnn.h ] ; then
    echo ">> cudnn is available"
  fi
fi

### perl (brew)
# TODO: fix error (see log
# if [ ! $INTERNET_IS_ACTIVE ] ; then
#   PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
#   eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"
# fi

### homebrew
if [ `uname` = "Darwin" ] && [ -n `which brew` ] && [ -d $PYENV_ROOT ] ; then
  alias brew="env PATH=${PATH/${PYENV_ROOT}\/shims:/} brew"
fi

### emax
[ -d $HOME/work/emaxv/nakashim/proj-arm64.cent ] && \
  export EMAXV_SIML_PROJ_ROOT="$HOME/work/emaxv/nakashim/proj-arm64.cent"
[ -d $EMAXV_SIML_PROJ_ROOT/bin ] && \
  export PATH=$EMAXV_SIML_PROJ_ROOT/bin:$PATH
[ -d $EMAXV_SIML_PROJ_ROOT/lib ] && \
  export LD_LIBRARY_PATH=$EMAXV_SIML_PROJ_ROOT/lib:$LD_LIBRARY_PATH
[ -d "$HOME/works/nakashim/proj-arm64.cent/lib/asim64-lib" ] && \
  export LD_LIBRARY_PATH="$HOME/works/nakashim/proj-arm64.cent/lib/asim64-lib:$LD_LIBRARY_PATH"

### cad tools
case `$cmd_hostname` in
  "cad110.naist.jp" )
    if [ `uname` = Linux ] && [ -s /opt/xilinx/ise101/ISE/settings64.csh ] ; then
      echo "=========================================="
      echo "======== ISE101/GP8M is available ========"
      echo "=========================================="
      source /opt/xilinx/ise101/ISE/settings64.csh
    fi
  ;;
  "cad101.naist.jp" | "cad102.naist.jp" )
    if [ `uname` = Linux ] && [ -s /opt/xilinx/ise123/settings64.csh ] ; then
      source /opt/xilinx/ise123/settings64.csh
      echo "=========================================="
      echo "======== ISE123/GP5V is available ========"
      echo "=========================================="
    fi
    ;;
  "arch16.naist.jp" | "arch17.naist.jp" )
    if [ `uname` = Linux ] && [ -s /opt/xilinx/ise134/settings64.csh ] ; then
      source /opt/xilinx/ise134/settings64.csh
      echo "=========================================="
      echo "======== ISE134/GP6V is available ========"
      echo "=========================================="
    fi
    ;;
  "cad111.naist.jp" | "cad112.naist.jp" | "cad113.naist.jp" | "cad114.naist.jp" )
    # if [ `uname` = Linux ] && [ -s /opt/xilinx/ise134/settings64.csh ] ; then
    #   source /opt/vdec/setup/vdec_tools.2016.cshrc
    if [ `uname` = Linux ] && [ -s $HOME/work/emaxv/vdec_tools.2016.cshrc ] ; then
      source $HOME/work/emaxv/vdec_tools.2016.cshrc
      echo "=========================================="
      echo "======== VDEC Tools are available ========"
      echo "=========================================="
    fi
    ;;
esac

case `$cmd_hostname` in
  "arch09.naist.jp" | "cad101.naist.jp" | "cad102.naist.jp" | \
  "cad103.naist.jp" | "cad104.naist.jp" | "cad115.naist.jp" | \
  "cad116.naist.jp" | "cad117.naist.jp" | "cad118.naist.jp" )
    if [ `uname` = Linux ] && [ -s /opt/xilinx/Vivado/2016.2/settings64.csh ] ; then
      source /opt/xilinx/Vivado/2016.2/settings64.csh
      echo "=========================================="
      echo "======== Vivado/ZYNQ is available ========"
      echo "=========================================="
      echo "Vivado: $XILINX_VIVADO"
    fi
    ;;
esac

# case `$cmd_hostname` in
#   "cad101.naist.jp" | "cad102.naist.jp" | "cad106.naist.jp" | "cad107.naist.jp" )
#     if [ `uname` = Linux ] && [ -s /opt/xilinx/PetaLinux/petalinux-v2016.4-final/settings.csh ] ; then
#       source /opt/xilinx/PetaLinux/petalinux-v2016.4-final/settings.csh /opt/xilinx/PetaLinux/petalinux-v2016.4-final
#       echo "========================================"
#       echo "======== Petalinux is available ========"
#       echo "========================================"
#     fi
#     ;;
#  esac


### remove duplicate of PATH
__remove_duplicate() {
  _env=""
  _env_name="$1"
  _ENV="${!1}"
  for _e in $(echo $_ENV | tr ':' ' '); do
    case ":${_env}:" in
      *:"${_e}":* )
        ;;
      * )
        if [ "$_env" ]; then
          _env="$_env:$_e"
        else
          _env=$_e
        fi
        ;;
    esac
  done
  eval "$_env_name=$_env"
  unset _e
  unset _env
  unset _env_name
  unset _ENV
}
__remove_duplicate "PATH"
__remove_duplicate "LD_LIBRARY_PATH"
