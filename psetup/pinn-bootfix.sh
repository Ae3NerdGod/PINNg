#!/bin/bash
 fixvm=0
 fixrd=0
 firstrun=1
while true; do
    if [[ $fixvm == 1 ]] || [[ $fixrd == 1 ]] || [[ $firstrun == 1 ]]
    then
        echo checking files
    while true; do
        donttouch=0
        for a in /boot/vm* /boot/*.img /var/lib/dpkg/lock
        do
            lsof $a >/dev/null 2>&1
            [ $? = 0 ] && donttouch=1
        done
        [ $donttouch = 1 ] && echo files in use || break
        sleep 10
    done
	firstrun=0
    fi

    if [[ $fixvm == 1 ]]
    then
        cp -Lf /boot/vmlinuz /boot/firmware/vmlinuz
        gzip -dc /boot/firmware/vmlinuz > /boot/firmware/vmlinux && fixvm=0 echo kernel unzipped
        fixrd=1
    fi

    if [[ $fixrd == 1 ]]
    then
		if [ -z "$initrdmatch" ]
		then
			initrdmatch=initrd.img`readlink /boot/vmlinuz|sed 's/vmlinuz//g'`
		fi
        cp -Lf /boot/$initrdmatch /boot/firmware/initrd.img && fixrd=0 echo ramdisk copied
    fi
    sleep 5
    fixvm=0
    fixrd=0
    vmsha=$(shasum /boot/vmlinuz| awk '{ print $1 }')
    initrdmatch=initrd.img`readlink /boot/vmlinuz|sed 's/vmlinuz//g'`
    rdsha=$(shasum /boot/$initrdmatch| awk '{ print $1 }')
    vmshacheck=$(shasum /boot/firmware/vmlinuz| awk '{ print $1 }')
    rdshacheck=$(shasum /boot/firmware/initrd.img| awk '{ print $1 }')
    [[ "$vmsha" == "$vmshacheck" ]] || fixvm=1 
    [[ "$rdsha" == "$rdshacheck" ]] || fixrd=1 
    [ ! -f /boot/firmware/vmlinux ] && fixvm=1
    [ ! -f /boot/firmware/initrd.img ] && fixrd=1
done
exit 0

