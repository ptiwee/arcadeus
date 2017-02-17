#!/bin/sh
# Script to scan USB device and generate attractmode romlists
#
platforms="arcade|zip
nes|nes
snes|sfc
n64|n64
gameboy|gb
gbc|gbc
gba|gba
sms|sms
megadrive|md
gamegear|gg
neogeo|zip
ngpx|ngc
playstation|bin"

romsdir=/mnt
attractdir=/mnt/attract

IFS="
"

case "$1" in
    start)
        echo "Generating AttractMode romlist"

        mkdir -p $attractdir/romlists
        mkdir -p $attractdir/emulators

        cp /usr/share/attract/emulators/* $attractdir/emulators/

        # General configuration
        if [ ! -f $attractdir/attract.cfg ]; then
            echo -e "general" >> $attractdir/attract.cfg
            echo -e "\tdefault_font\tDejaVuSans" >> $attractdir/attract.cfg
            echo -e "input_map" >> $attractdir/attract.cfg
            echo -e "\tdefault\tup\tprev_display" >> $attractdir/attract.cfg
            echo -e "\tdefault\tdown\tnext_display" >> $attractdir/attract.cfg
            echo -e "\tdefault\tleft\tprev_game" >> $attractdir/attract.cfg
            echo -e "\tdefault\tright\tnext_game" >> $attractdir/attract.cfg

            for info in $platforms
            do
                platform=$(echo "$info" | cut -d\| -f1)

                echo -e "display\t$platform" >> $attractdir/attract.cfg
                echo -e "\tlayout\tFlat" >> $attractdir/attract.cfg
                echo -e "\tromlist\t$platform" >> $attractdir/attract.cfg
                echo -e "\tin_cycle\tno" >> $attractdir/attract.cfg
                echo -e "\tin_menu\tno" >> $attractdir/attract.cfg
                echo -e "" >> $attractdir/attract.cfg
            done
        fi

        for info in $platforms
        do
            platform=$(echo "$info" | cut -d\| -f1)
            platform_ext=$(echo "$info" | cut -d\| -f2)

            if [ -d $romsdir/$platform ]; then
                sum=$(ls -l $romsdir/$platform | md5sum)
            else
                sum="00000000000000000000000000000000"
            fi

            if [ -e "$attractdir/romlists/$platform.txt" ]; then
                oldsum=$(sed '$s/^#\(.*\)/\1/' "$attractdir/romlists/$platform.txt" | tail -n1)
            else
                oldsum="11111111111111111111111111111111"
            fi

            if [ "$sum" != "$oldsum" ]; then
                if [ -e "$attractdir/romlists/$platform.txt" ]; then
                    # Remove old list
                    rm $attractdir/romlists/$platform.txt
                fi

                for rom in `ls -1v $romsdir/$platform/*.$platform_ext 2> /dev/null`
                do
                    if [ -f "$rom" ]; then
                        ext=$(basename "$rom" | sed "s/^.*\.\(.*$\)$/\1/")
                        basename=$(basename "$rom")
                        name=$(echo "$basename" | sed "s/^\(.*\)\..*$/\1/")
                        valid=1

                        if [ -f "$romsdir/$platform/$name.txt" ]; then
                            # Extract informations from txt file
                            title=$(cat "$romsdir/$platform/$name.txt" | sed -n '1p')
                            manufacturer=$(cat "$romsdir/$platform/$name.txt" | sed -n '2p')
                            year=$(cat "$romsdir/$platform/$name.txt" | sed -n '3p')
                            extra=$(cat "$romsdir/$platform/$name.txt" | sed -n '4p')
                        else
                            title=$(echo $name | sed "s/\([^(\[]*\).*$/\1/" | sed "s/\s*$//g")
                            manufacturer=""
                            year=""
                            extra=""
                        fi

                        if [ -f $romsdir/$platform/blacklist.txt ]; then
                            grep -q "$basename" $romsdir/$platform/blacklist.txt
                            if [ $? == 0 ]; then
                                valid=0
                            fi
                        fi

                        if [ $valid == 1 ]; then
                            echo "$name;$title;$platform;;$year;$manufacturer;;;;;;;;;;$extra" >> "$attractdir/romlists/$platform.txt"
                        fi
                    fi
                done

                if [ -f $attractdir/romlists/$platform.txt ]; then
                    echo -e "#$sum" >> $attractdir/romlists/$platform.txt

                    # Enable the display
                    sed -i "/display\s$platform/{n;n;n;s/no/yes/}" $attractdir/attract.cfg
                    sed -i "/display\s$platform/{n;n;n;n;s/no/yes/}" $attractdir/attract.cfg
                else
                    # Disable the display
                    sed -i "/display\s$platform/{n;n;n;s/yes/no/}" $attractdir/attract.cfg
                    sed -i "/display\s$platform/{n;n;n;n;s/yes/no/}" $attractdir/attract.cfg
                fi
            fi
        done
        ;;
    stop)
        ;;
esac
