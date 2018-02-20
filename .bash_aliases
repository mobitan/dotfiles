#
#   	Ikki's .bash_aliases
#
# 2015/05/16	Moved from .bashrc

alias ls='ls -v'
alias ll='ls -vl'
alias la='ls -vlA'
alias lh='ls -vlh'
alias lt='ls -vltr'
alias df='df -h'
alias du='du -sh'
alias c='i2cssh -F --profile Ikki'

function browse() {
	if [ "$1" = "" ]; then
		ls
	elif [ "$1" = "-" ]; then
		cd -
		ls
	elif [ -d "$1" ]; then
		cd "$1"
		ls
	elif [ -x /usr/bin/lv ]; then
		lv "$1"
	else
		less "$1"
	fi
}
alias d='browse'
alias s='ssh'
