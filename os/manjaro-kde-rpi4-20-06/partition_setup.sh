#!/bin/sh
#supports_backup in PINN

set -ex

# shellcheck disable=SC2154
#if [ -z "$part1" ] || [ -z "$part2" ]; then
 # printf "Error: missing environment variable part1 or part2\n" 1>&2
 # exit 1
#fi
if [ -z "$id1" ] || [ -z "$id2" ]; then
  printf "Error: missing environment variable id1 or id2\n" 1>&2
  exit 1
fi

mkdir -p /tmp/1 /tmp/2

mount "$part1" /tmp/1
mount "$part2" /tmp/2

#sed /tmp/1/cmdline.txt -i -e "s|root=[^ ]*|root=${part2}|"
#sed /tmp/2/etc/fstab -i -e "s|^[^#].* / |${part2}  / |"
#sed /tmp/2/etc/fstab -i -e "s|^[^#].* /boot |${part1}  /boot |"

sed /tmp/1/cmdline.txt -i -e "s|root=[^ ]*|root=${id2}|"
sed /tmp/2/etc/fstab -i -e "s|^[^#].* / |${id2}  / |"
sed /tmp/2/etc/fstab -i -e "s|^[^#].* /boot |${id1}  /boot |"
sed -i '/resize-fs/d' /tmp/2/usr/share/manjaro-arm-oem-install/manjaro-arm-oem-install

echo "[Trigger]" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "Type = File" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "Operation = Install" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "Operation = Upgrade" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "Operation = Remove" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "Target = boot/cmdline.txt" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "[Action]" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "Description = Running PINN post install partition setup..." >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "When = PostTransaction" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook
echo "Exec = /usr/bin/sed /boot/cmdline.txt -i -e \"s|root=[^ ]*|root=${id2}|\" " >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn.hook

echo "[Trigger]" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "Type = File" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "Operation = Install" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "Operation = Upgrade" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "Operation = Remove" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "Target = etc/fstab" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "[Action]" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "Description = Running PINN post install fstab setup..." >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "When = PostTransaction" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook
echo "Exec = /usr/bin/sed /etc/fstab -i -e \"s|^[^#].* / |${id2}  / |\" " >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab.hook

echo "[Trigger]" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "Type = File" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "Operation = Install" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "Operation = Upgrade" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "Operation = Remove" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "Target = etc/fstab" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "[Action]" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "Description = Running PINN post install fstab setup..." >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "When = PostTransaction" >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook
echo "Exec = /usr/bin/sed /etc/fstab -i -e \"s|^[^#].* /boot |${id1}  /boot |\" " >>/tmp/2/usr/share/libalpm/hooks/60-linux-rpi-pinn-fstab-boot.hook

# shellcheck disable=SC2154
if [ -z "$restore" ]; then
  if [ -f /mnt/ssh ]; then
    cp /mnt/ssh /tmp/1/
  fi

  if [ -f /mnt/ssh.txt ]; then
    cp /mnt/ssh.txt /tmp/1/
  fi

  if [ -f /settings/wpa_supplicant.conf ]; then
    cp /settings/wpa_supplicant.conf /tmp/1/
  fi

  if ! grep -q resize /proc/cmdline; then
    if ! grep -q splash /tmp/1/cmdline.txt; then
      sed -i "s| quiet||g" /tmp/1/cmdline.txt
    fi
    sed -i 's| init=/usr/lib/raspi-config/init_resize.sh||' /tmp/1/cmdline.txt
  else
    sed -i '1 s|.*|& sdhci.debug_quirks2=4|' /tmp/1/cmdline.txt
  fi
fi

umount /tmp/1
umount /tmp/2

