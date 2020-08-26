#!/bin/sh
#supports_backup in PINN

set -ex

# shellcheck disable=SC2154
#if [ -z "$partuuid1" ] || [ -z "$partuuid2" ]; then
 # printf "Error: missing environment variable partuuid1 or partuuid2\n" 1>&2
 # exit 1
#fi
if [ -z "$id1" ] || [ -z "$id2" ]; then
  printf "Error: missing environment variable id1 or id2\n" 1>&2
  exit 1
fi

mkdir -p /tmp/1 /tmp/2

mount "$partuuid1" /tmp/1
mount "$partuuid2" /tmp/2

sed /tmp/1/cmdline.txt -i -e "s|root=[^ ]*|root=${partuuid2}|"
sed /tmp/2/etc/fstab -i -e "s|^[^#].* / |${partuuid2}  / |"
sed /tmp/2/etc/fstab -i -e "s|^[^#].* /boot |${partuuid1}  /boot |"


umount /tmp/1
umount /tmp/2

