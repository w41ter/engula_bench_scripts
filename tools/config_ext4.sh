#!/bin/bash

# /dev/vda1 on / type ext4 (rw,noatime,nodelalloc,errors=remount-ro)
# echo "(rw,noatime,nodelalloc,errors=remount-ro)" | tr -d '()'
function read_mount_options() {
    local dev=$1
    mount | fgrep $dev | awk '{print $NF}' | tr -d '()'
}

function read_mount_point() {
    local dev=$1
    mount | fgrep $dev | awk '{print $3}'
}

function remount() {
    local dev=$1
    local options="$(read_mount_options ${dev})"
    options=( $(echo ${options} | awk -F',' '{ for(i=1;i<=NF;i++) { print $i } }') )
    options=( ${options[*]} nodelalloc noatime )
    options=( $(printf "%s\n" "${options[@]}" | sort -u) )
    options=$(printf ",%s" "${options[@]}")
    options=${options:1}

    local point="$(read_mount_point ${dev})"
    mount -o${options},remount ${point}
}

cp /etc/fstab /etc/fstab.bak

for DEV in $( mount | grep ext4 | awk '{print $1}' | fgrep /dev/ ); do
    PUREDEV=$( echo $DEV | cut -d/ -f3- )
    UUIDIS=$( ls -l /dev/disk/by-uuid/ | fgrep $PUREDEV | awk '{print $9}' )
    remount ${PUREDEV}
    sed -i "/${UUIDIS}/d" /etc/fstab
    left=$(cat /etc/mtab | grep ${DEV} | awk '{ $1=""; print $0 }')
    echo "UUID=${UUIDIS} ${left}" >> /etc/fstab
done

# echo `blkid /dev/vdb1 | awk '{print $2}' | sed 's/\"//g'` /mnt ext4 rw,noatime,nodelalloc,errors=remount-ro 0 0 >> /etc/fstab

systemctl daemon-reload
