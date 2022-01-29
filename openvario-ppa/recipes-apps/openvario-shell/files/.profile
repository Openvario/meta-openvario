# ~/.profile: executed by Bourne-compatible login shells.

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

if [[ $(tty) = /dev/tty1 ]]
then
    clear
    echo Starting Openvario shell...
    LANG=en_US.UTF-8 ovshell
fi
