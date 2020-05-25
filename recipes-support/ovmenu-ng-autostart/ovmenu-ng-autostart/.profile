# ~/.profile: executed by Bourne-compatible login shells.

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# path set by /etc/profile
# export PATH

export TSLIB_TSDEVICE=/dev/input/event5

if ! [ "$(pidof ovmenu-ng.sh)" ]
then
  /opt/bin/ovmenu-ng.sh
fi
