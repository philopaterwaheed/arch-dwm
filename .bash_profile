#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ ! $DISPLAY && $(tty) = "/dev/tty1" ]] && startx
export _JAVA_AWT_WM_NONREPARENTING=1


