# ~/.profile: executed by Bourne-compatible login shells.

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# path set by /etc/profile
# export PATH

if ! [ "$(pidof ovmenu)" ]
then
  /opt/bin/ovmenu -r 640x480
fi
