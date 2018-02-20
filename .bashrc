#
#   	Ikki's .bashrc for Mac/Ubuntu/CentOS
#
# 2015/05/16	Merged with the default one of AWS Ubuntu 14.04
# 2016/10/11	Moved environment variables to .bash_profile
# 2017/02/13	Moved pyenv back to .bashrc
# 2017/05/17	Added env_parallel.bash
# 2017/05/24	Added java
# 2017/11/30	Added ~/.gem/ruby/2.0.0/bin to PATH
# 2017/12/20	Added ~/tools to PATH
# 2017/12/22	Moved 'pyenv is disabled' message to the last

enable_pyenv=true

function pathmunge () {
	case ":${PATH}:" in
	*:"$1":*) ;;
	*)
		if [ "$2" = "after" ]; then
			PATH=$PATH:$1
		else
			PATH=$1:$PATH
		fi
	esac
	export PATH
}

# RubyGems
if [[ -d $HOME/.gem/ruby/2.0.0/bin ]]; then
	pathmunge $HOME/.gem/ruby/2.0.0/bin
fi

# java
if [[ -d /opt/JDK ]]; then
	# point to the newest version
	export JAVA_HOME=`ls -drv /opt/JDK/* | head -n1`
	pathmunge $JAVA_HOME/bin
	pathmunge $HOME/local/maven/bin
fi

# cuda
if [[ -d /usr/local/cuda ]]; then
	export CUDA_ROOT=/usr/local/cuda
	export CUDA_PATH=$CUDA_ROOT
	export CPATH=$CUDA_ROOT/include${CPATH:+:${CPATH}}
	export C_INCLUDE_PATH=$CUDA_ROOT/include${C_INCLUDE_PATH:+:${C_INCLUDE_PATH}}
	export CPLUS_INCLUDE_PATH=$CUDA_ROOT/include${CPLUS_INCLUDE_PATH:+:${CPLUS_INCLUDE_PATH}}
	export LIBRARY_PATH=$CUDA_ROOT/lib64${LIBRARY_PATH:+:${LIBRARY_PATH}}
	export LD_LIBRARY_PATH=$CUDA_ROOT/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
	export DYLD_LIBRARY_PATH=$CUDA_ROOT/lib64${DYLD_LIBRARY_PATH:+:${DYLD_LIBRARY_PATH}}
	export LD_RUN_PATH=$CUDA_ROOT/lib64${LD_RUN_PATH:+:${LD_RUN_PATH}}
	pathmunge $CUDA_ROOT/bin
fi

# parallel
if [[ -r $HOME/local/bin/env_parallel.bash ]]; then
	source $HOME/local/bin/env_parallel.bash
fi

# pyenv
if [[ $enable_pyenv == true && -d $HOME/.pyenv ]]; then
	pathmunge $HOME/.pyenv/bin
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
	export PYENV_VIRTUALENV_DISABLE_PROMPT=1
fi

# torch
case `hostname -s` in
nlp-iax-*) TORCH_ROOT=$HOME/local/torch.nlp-iax ;;
mccnlp*)   TORCH_ROOT=$HOME/local/torch.mccnlp ;;
*)         TORCH_ROOT=$HOME/local/torch.`hostname -s` ;;
esac
if [[ -r $TORCH_ROOT/install/bin/torch-activate ]]; then
	case ":${PATH}:" in
	*:"$TORCH_ROOT/install/bin":*) ;;
	*) source $TORCH_ROOT/install/bin/torch-activate ;;
	esac
fi

# local
if [[ -d $HOME/local ]]; then
	LOCAL_ROOT=$HOME/local
	export CPATH=$LOCAL_ROOT/include${CPATH:+:${CPATH}}
	export C_INCLUDE_PATH=$LOCAL_ROOT/include${C_INCLUDE_PATH:+:${C_INCLUDE_PATH}}
	export CPLUS_INCLUDE_PATH=$LOCAL_ROOT/include${CPLUS_INCLUDE_PATH:+:${CPLUS_INCLUDE_PATH}}
	export LIBRARY_PATH=$LOCAL_ROOT/lib${LIBRARY_PATH:+:${LIBRARY_PATH}}
	export LD_LIBRARY_PATH=$LOCAL_ROOT/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
	export DYLD_LIBRARY_PATH=$LOCAL_ROOT/lib${DYLD_LIBRARY_PATH:+:${DYLD_LIBRARY_PATH}}
	export LD_RUN_PATH=$LOCAL_ROOT/lib${LD_RUN_PATH:+:${LD_RUN_PATH}}
	pathmunge $LOCAL_ROOT/bin
fi
pathmunge $HOME/bin
pathmunge $HOME/tools

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# shopt -s globstar

# If set, bash includes filenames beginning with a ‘.’ in the results
# of pathname expansion.
shopt -s dotglob 

# If set, bash matches filenames in a case-insensitive fashion when
# performing pathname expansion.
shopt -s nocaseglob

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt
# http://misc.flogisoft.com/bash/tip_colors_and_formatting
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	if [ "$USER" != "root" ]; then
	PS1='\n\[\e[1;37;104m\]\h\[\e[0;94;104m\]:\[\e[1;37;46m\]\w\[\e[0;36;46m\]\$\[\e[00m\] '
	else
	PS1='\n\[\e[1;37;105m\]\h\[\e[0;95;105m\]:\[\e[1;37;45m\]\w\[\e[0;35;45m\]\$\[\e[00m\] '
	fi
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -vhF --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# User specific aliases and functions
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# pyenv
if [[ ! $PATH =~ "/.pyenv/shims:" ]]; then
	echo "pyenv is disabled"
fi

# byobu
# echo -e "\033k`hostname -s`\033\\" # When we get tmux 1.9, use automatic-rename-format
