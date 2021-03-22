#!/bin/sh
topic() {
    echo "---> $1"
}
UBUNTU_VERSION=20.04.2.0
if [ ! -f disk.img ]; then
    topic "Creating disk.img as raw disk image..."
    qemu-img create -f raw disk.img 10G
fi
if [ ! -f ubuntu-${UBUNTU_VERSION}-desktop-amd64.iso ]; then
    topic "Fetching Ubuntu ISO..."
    wget https://releases.ubuntu.com/${UBUNTU_VERSION}/ubuntu-${UBUNTU_VERSION}-desktop-amd64.iso
fi
topic "Installing basic Ubuntu disk image..."
echo "Follow the Ubuntu installer and close the window when finished."
echo "Choose the MBR partition scheme with a ext4 partition mounted on /"
qemu-system-x86_64 -hda disk.img -cdrom ubuntu-${UBUNTU_VERSION}-desktop-amd64.iso -m 2G -boot d
topic "Mounting disk.img on a loop device..."
loop_device=$(losetup --partscan --show --find disk.img)
topic "Mounting the ext4 filesystem..."
read -p "Filesystem mount point: " mount_point
mount -t ext4 ${loop_device}p1 $mount_point
topic "Unmounting disk.img and the ext4 filesystem..."
umount $mount_point
losetup -d $loop_device
