#!/bin/sh
set -e
topic() {
    echo "---> $1"
}
UBUNTU_VERSION=20.04.2
UBUNTU_ARCH=amd64
UBUNTU_BASE_FILE=ubuntu-base-$UBUNTU_VERSION-base-$UBUNTU_ARCH.tar.gz
format_partition=false
if ! [ -f disk.img ]; then
    topic "Create disk.img as raw 3G disk image"
    qemu-img create -f raw disk.img 3G
    topic "Format disk.img as MBR with ext4 partition"
    printf "o\nn\np\n1\n\n\na\nw\n" | fdisk disk.img
    format_partition=true
fi
topic "Mount disk.img on a loop device"
loop_device=$(losetup --partscan --show --find disk.img)
if [ $format_partition = true ]; then
    topic "Format ext4 partition"
    mkfs.ext4 ${loop_device}p1
fi
topic "Mount ext4 filesystem"
read -p "Mount point: " mount_point
mount -t ext4 ${loop_device}p1 $mount_point
if ! [ -f $mount_point/bin/sh ]; then
    if ! [ -f $UBUNTU_BASE_FILE ]; then
        topic "Fetch $UBUNTU_BASE_FILE"
        wget https://cdimage.ubuntu.com/ubuntu-base/releases/20.04.2/release/$UBUNTU_BASE_FILE
    fi
    topic "Extract $UBUNTU_BASE_FILE"
    tar -xf $UBUNTU_BASE_FILE -C $mount_point
fi
topic "Unmount loop device and ext4 filesystem"
umount $mount_point
losetup -d $loop_device
