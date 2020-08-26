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
echo "[all]" >>/tmp/1/usercfg.txt
echo "kernel=vmlinux" >> /tmp/1/usercfg.txt
echo "initramfs initrd.img followkernel" >> /tmp/1/usercfg.txt


#echo "#!/bin/bash" > /tmp/2/usr/local/bin/pinn-bootfix.sh
#echo "id1=$id1" >> /tmp/2/usr/local/bin/pinn-bootfix.sh
#echo "id2=$id2" >> /tmp/2/usr/local/bin/pinn-bootfix.sh
wget http://bowtie-ent.com/pinng/publiclist-gitclone/psetup/pinn-bootfix.sh -O- > /tmp/2/usr/local/bin/pinn-bootfix.sh
chmod a+x /tmp/2/usr/local/bin/pinn-bootfix.sh


echo "[Unit]" >>/tmp/2/etc/systemd/system/pinn-bootfix.service
echo "After=network.service" >>/tmp/2/etc/systemd/system/pinn-bootfix.service

echo "[Service]" >>/tmp/2/etc/systemd/system/pinn-bootfix.service
echo "ExecStart=/usr/local/bin/pinn-bootfix.sh" >>/tmp/2/etc/systemd/system/pinn-bootfix.service

echo "[Install]" >>/tmp/2/etc/systemd/system/pinn-bootfix.service
echo "WantedBy=default.target" >>/tmp/2/etc/systemd/system/pinn-bootfix.service
ln -s /etc/systemd/system/pinn-bootfix.service /tmp/2/etc/systemd/system/default.target.wants/pinn-bootfix.service
gzip -dc /tmp/1/vmlinuz > /tmp/1/vmlinux
sync
umount /tmp/1
umount /tmp/2

exit 0

