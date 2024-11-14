# /etc/profile.d/im-config_wayland.sh
#
# This sets the IM variables on Wayland.

test "$XDG_SESSION_TYPE" = 'wayland' || return 0

# don't do anything if im-config was removed but not purged
 test -r /usr/share/im-config/xinputrc.common || return

if [ -r /etc/X11/Xsession.d/70im-config_launch ]; then
    . /etc/X11/Xsession.d/70im-config_launch
fi
