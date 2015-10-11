#! /bin/sh

SRCDIR="$(dirname "$0")"

. "$SRCDIR/panel_colors"

# PANEL_FIFO=/tmp/bspwm-panel-dzen2
PANEL_HEIGHT=20
PANEL_WIDTH=1920
FONT='-*-terminus-medium-r-normal-*-12-120-72-72-c-60-*-*'
# FONT='-*-terminus-medium-r-normal-*-12-120-72-72-c-60-iso10646-1'
# FONT='-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*'
# FONT='-*-droidsans-*-r-normal-*-*-80-*-*-*-*-*-*'
# FONT='xft:Ubuntu:pixelsize=12:antialias=false:hinting=true'

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

# [ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
# mkfifo "$PANEL_FIFO"

bspc config top_padding $PANEL_HEIGHT

bspc control --subscribe | "$SRCDIR/dzen_panel.sh" | LANG=ru_RU dzen2 -xs 2 -h $PANEL_HEIGHT -w $PANEL_WIDTH -ta l -fg $COLOR_FOREGROUND -bg $COLOR_BACKGROUND -fn $FONT
