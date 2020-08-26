#!/bin/sh
set -ex

mkdir -p /tmp/1 /tmp/2

mount "$partuuid1" /tmp/1
mount "$partuuid2" /tmp/2
for cmdline in /tmp/1/nobtcmd.txt /tmp/1/btcmd.txt /tmp/1/cmdline.txt
do
	if [ -f "$cmdline" ]
	then
		
		sed $cmdline -i -e "s|root=[^ ]*|root=${partuuid2}|"
	fi
done
rm /tmp/2/etc/fstab
echo "$partuuid2 / ext4 defaults 0 0" > /tmp/2/etc/fstab
echo "$partuuid1 /boot/firmware vfat defaults 0 1" >> /tmp/2/etc/fstab
if [ -f /tmp/1/usercfg.txt ]
then
echo "[all]" >>/tmp/1/usercfg.txt
echo "device_tree_address=0x03000000" >> /tmp/1/usercfg.txt
echo "kernel=vmlinuz" >> /tmp/1/usercfg.txt
echo "initramfs initrd.img followkernel" >> /tmp/1/usercfg.txt
fi

umount /tmp/1
umount /tmp/2

exit 0

