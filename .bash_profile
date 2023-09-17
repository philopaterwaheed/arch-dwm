#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ ! $DISPLAY && $(tty) = "/dev/tty1" ]] && startx

