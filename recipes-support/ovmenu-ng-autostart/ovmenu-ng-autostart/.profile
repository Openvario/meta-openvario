# ~/.profile: executed by Bourne-compatible login shells.

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# path set by /etc/profile
# export PATH

if ! [ "$(pidof ovmenu-ng.sh)" ]
then
  /opt/bin/ovmenu-ng.sh
fi
