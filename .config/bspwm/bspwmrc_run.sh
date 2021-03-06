#!/bin/sh

required_cmds=(
    "/usr/bin/clipit"
    "/usr/bin/compton"
    # "/usr/bin/dzen2"
    "/usr/bin/gnome-keyring-daemon"
    "/usr/bin/nitrogen"
    "/usr/bin/nm-applet"
    "/usr/bin/pa-applet"
    "/usr/bin/redshift"
    # "/usr/bin/setxkbmap"
    "/usr/bin/sleep"
    # "/usr/bin/synclient"
    "/usr/bin/terminator"
    "/usr/bin/thunar"
    "/usr/bin/tilda"
    "/usr/bin/tint2"
    # "/usr/bin/unclutter"
    # "/usr/bin/volumeicon"
    # "/usr/bin/wmname"
    "/usr/bin/xbindkeys"
    "/usr/bin/xfce4-power-manager"
    "/usr/bin/xkbcomp"
    "/usr/bin/xmodmap"
    "/usr/bin/xrandr"
    "/usr/bin/xscreensaver"
    "/usr/bin/xset"
    "/usr/bin/xsetroot"
    "/usr/local/bin/sxhkd"
    "/usr/bin/zenity"
)

for cmd in "${required_cmds[@]}"; do
    if [ -x "/usr/bin/notify-send" ]; then
        [ ! -x "${cmd}" ] && /usr/bin/notify-send "${cmd} not exist" &
    else
        [ ! -x "${cmd}" ] && echo "${cmd} not exist" >> "$HOME/bspwm_autorun.log" &
    fi
done


# Two monitor config
if [[ $(/usr/bin/xrandr -q | /bin/grep " connected " | /usr/bin/wc -l) == 2 ]]; then
    (/usr/bin/xrandr --output DVI-0 --mode 1920x1080) &
    (/usr/bin/xrandr --output HDMI-2 --mode 1920x1080) &
    (sleep 3s && /usr/bin/xrandr --output DVI-0 --left-of HDMI-2) &
    (/usr/bin/xrandr --output DVI-0 --primary) &
fi

(pidof /usr/local/bin/sxhkd || sxhkd >> ~/.sxhkd.log) &

## GNOME PolicyKit and Keyring
eval $(/usr/bin/gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg) &

## Redshift 
# adjusts the color temperature of your screen according to your surroundings. 
# This may help your eyes hurt less if you are working in front of the screen at night.
# This program is inspired by f.lux.
(pidof /usr/bin/redshift || (/usr/bin/redshift -l 50.0318313:36.2242183 -t 6500:4500 -b 1:0.9 -m randr & DISPLAY=:8  /usr/bin/redshift -l 50.0318313:36.2242183 -t 6500:5000 -b 1:0.9 -m randr)) &

## sample X compositing manager
(pidof /usr/bin/compton || /usr/bin/compton) &

# Fix for Java applications
/usr/bin/wmname LG3D &
# 
/usr/bin/xsetroot -cursor_name left_ptr &

## Set root window color
/usr/bin/xsetroot -solid "#2E3436" &

## Wallpaper
( sleep 4s && /usr/bin/nitrogen --restore ) &

## Set keyboard settings - 250 ms delay and 25 cps (characters per second) repeat rate.
## Adjust the values according to your preferances.
/usr/bin/xset r rate 250 25 &

## Set mouse speed
/usr/bin/xset m 3 3 &
xset -dpms &

# disable screensaver
xset s off &

# update X config
xrdb ~/.Xresources &

## Detect and configure touchpad. See 'man synclient' for more info.
if egrep -iq 'touchpad' /proc/bus/input/devices; then
    synclient VertEdgeScroll=1 &
    synclient TapButton1=1 &
fi

## Hide mouse pointer after 1 sec idle
# (pidof /usr/bin/unclutter || /usr/bin/unclutter -idle 1) &

## Turn on/off system beep
/usr/bin/xset b off &

## Horizontal scroll with shift+mousewheel
xbindkeys &

## Add russian layout
# setxkbmap -layout us,ru -option '' -option grp:caps_toggle -option grp_led:caps -option shift:breaks_caps &
setxkbmap -option -layout us,ru -option grp:caps_toggle -option grp_led:caps -option shift:breaks_caps -option lv3:ralt_switch &
# https://wiki.archlinux.org/index.php/Xmodmap
# https://wiki.archlinux.org/index.php/X_KeyBoard_extension#Level3
#xkbcomp -w 0 -I$HOME/.config/xkb $HOME/.config/xkb/keymap.xkb $DISPLAY &

## Enable power management
(pidof xfce4-power-manager || xfce4-power-manager) &

## Start Thunar Daemon
(pidof /usr/bin/thunar || thunar --daemon) &

## Volume icon
(pidof /usr/bin/pa-applet || /usr/bin/pa-applet) &

## Enable Eyecandy - off by default, uncomment one of the commands below.  
## Note: cairo-compmgr prefers a sleep delay, else it tends to prodЁЁuce
## odd shadows/quirks around tint2 & Conky.
#(sleep 10s && gb-compmgr --cairo-compmgr) &
#gb-compmgr --xcompmgr & 

## Panels
(pidof tint2 || tint2) &
# (pidof dzen2 || $HOME/.config/bspwm/panel/panel.sh) &
# (sleep 4s && PATH=$PATH:$HOME/.config/bspwm/panel PANEL_FIFO="/tmp/panel-fifo" panel) &

## Launch network manager applet
(pidof nm-applet || nm-applet) &

## Start xscreensaver
(pidof xscreensaver || xscreensaver -no-splash) &

## Start Clipboard manager
(pidof clipit || clipit) &

## Top tilda
(pidof tilda || tilda) &

## Right ALT = Super_Lq
# xmodmap -e "keycode 108 = Super_L" &
# xmodmap -e "remove mod1 = Super_L" &

## Fix for normal mouse click on statusbar for non-english layouts
# for awesome wm
# xkbcomp $DISPLAY - | egrep -v "group . = AltGr;" | xkbcomp - $DISPLAY &

# [ ! -s ~/.mpd/pid ] && mpd &

terminator &
rofi &
# owncloud &
