#!/bin/sh

set -ex
mkdir -p /tmp/1 /tmp/2

mount "$part1" /tmp/1
mount "$part2" /tmp/2



sed /tmp/1/cmdline.txt -i -e "s|root=[^ ]*|root=${partuuid2}|"
sed /tmp/2/etc/fstab -i -e "s|^[^#].* / |${partuuid2}  / |"
sed /tmp/2/etc/fstab -i -e "s|^[^#].* /boot |${partuuid1}  /boot |"
sed -i '/resize-fs/d' /tmp/2/usr/share/manjaro-arm-oem-install/manjaro-arm-oem-install

echo "[Trigger]" >/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "Type = File" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "Operation = Install" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "Operation = Upgrade" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "Operation = Remove" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "Target = boot/cmdline.txt" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "[Action]" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "Description = Running PINN post install partition setup..." >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "When = PostTransaction" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "Exec = /usr/bin/sed /boot/cmdline.txt -i -e \"s|root=[^ ]*|root=${partuuid2}|\" " >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook

echo "[Trigger]" >/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "Type = File" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "Operation = Install" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "Operation = Upgrade" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "Operation = Remove" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "Target = etc/fstab" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "[Action]" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "Description = Running PINN post install fstab setup..." >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "When = PostTransaction" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "Exec = /usr/bin/sed /etc/fstab -i -e \"s|^[^#].* / |${partuuid2}  / |\" " >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook

echo "[Trigger]" >/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "Type = File" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "Operation = Install" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "Operation = Upgrade" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "Operation = Remove" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "Target = etc/fstab" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "[Action]" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "Description = Running PINN post install fstab setup..." >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "When = PostTransaction" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "Exec = /usr/bin/sed /etc/fstab -i -e \"s|^[^#].* /boot |${partuuid1}  /boot |\" " >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook

umount /tmp/1
umount /tmp/2

