#	.bash_profile for NICT

# LaTeX
export TEXINPUTS=./:$HOME/lib/texstyle:

# Mac OS X
export LESSCHARSET=utf-8

# X11 forwarding
#export DISPLAY=localhost:10.0

# Proxy
if [ "$HOSTNAME" = 'rinne' ]; then
	export http_proxy=http://proxy.nict.go.jp:3128
	export https_proxy=http://proxy.nict.go.jp:3128
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# 
case `hostname -s` in
nlp-*)
	export HOME=/nfs/home-01/$USER
	cd
esac
