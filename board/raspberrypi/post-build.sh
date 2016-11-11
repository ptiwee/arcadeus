#!/bin/sh

set -u
set -e

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi

# Add USB to fstab
sed -i '/^\/dev\/sda1/d' ${TARGET_DIR}/etc/fstab
echo '/dev/sda1\t/mnt\tvfat\tdefaults\t0\t0' >> ${TARGET_DIR}/etc/fstab
