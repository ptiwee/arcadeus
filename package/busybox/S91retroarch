#!/bin/sh

retroarchdir=/mnt/retroarch

case "$1" in
    start)
        mkdir -p $retroarchdir
        mkdir -p $retroarchdir/remaps
        mkdir -p $retroarchdir/savesate
        mkdir -p $retroarchdir/savefile

        if [ ! -e $retroarchdir/retroarch.cfg ]; then
            echo -e "config_save_on_exit = \"true\"" >> $retroarchdir/retroarch.cfg
            echo -e "input_max_users = \"2\"" >> $retroarchdir/retroarch.cfg
            echo -e "input_remapping_directory = \"$retroarchdir/remaps\"" >> $retroarchdir/retroarch.cfg
            echo -e "savefile_directory = \"$retroarchdir/savefile\"" >> $retroarchdir/retroarch.cfg
            echo -e "savestate_directory = \"$retroarchdir/savestate\"" >> $retroarchdir/retroarch.cfg
            echo -e "video_font_enable = \"false\"" >> $retroarchdir/retroarch.cfg
        fi
        ;;
    stop)
        ;;
esac
            
