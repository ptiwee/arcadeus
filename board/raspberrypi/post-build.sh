#!/bin/sh

set -u
set -e

# Autoload attractmode tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/usr/bin/attract -c /mnt/attract # attractmode' ${TARGET_DIR}/etc/inittab
fi

# Add USB to fstab
sed -i '/^\/dev\/sda1/d' ${TARGET_DIR}/etc/fstab
echo '/dev/sda1\t/mnt\tvfat\trw\t0\t0' >> ${TARGET_DIR}/etc/fstab
