#!/bin/sh
#supports_backup in PINN

set -ex
mkdir -p /tmp/1 /tmp/2

mount "$partuuid1" /tmp/1
mount "$partuuid2" /tmp/2

sed /tmp/1/cmdline.txt -i -e "s|root=[^ ]*|root=${partuuid2}|"
sed /tmp/2/etc/fstab -i -e "s|^[^#].* / |${partuuid2}  / |"
sed /tmp/2/etc/fstab -i -e "s|^[^#].* /boot |${partuuid1}  /boot |"


umount /tmp/1
umount /tmp/2

