#!/bin/sh
# Script to force boot sequence to wait for USB disk detection
# Copy to /etc/init.d/waitforusb
# ln -s /etc/init.d/waitforusb /etc/rcS.d/S25waitforusb
# Disk drive mount we're waiting on
usbdrive="/dev/sda1"
# Max time to wait (in seconds)
maxwait=30
case "$1" in
  start)
    echo "Waiting for USB disk drive $usbdrive"
    while [ ${maxwait} -gt 0 ]; do
      if [ -e "$usbdrive" ]; then
        printf "\n"
        # Repair filesystem
        fsck.vfat -a /dev/sda1
        mount /dev/sda1
        # Remove rec files created by fsck
        rm /mnt/*.REC
        exit 0
      fi
      sleep 1
      printf "."
      : $((maxwait -= 1))
    done
    printf "USB Timeout\n"
    exit 1
    ;;
esac

exit 0
