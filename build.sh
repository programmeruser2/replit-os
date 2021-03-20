#!/bin/sh
topic() {
    echo "---> $1"
}
UBUNTU_VERSION=20.04.2.0
if [ ! -f disk.img ]; then
    topic "Creating disk.img as raw disk image..."
    qemu-img create -f raw disk.img 5G
fi
if [ ! -f ubuntu-${UBUNTU_VERSION}-desktop-amd64.iso ]; then
    topic "Fetching Ubuntu ISO..."
    wget https://releases.ubuntu.com/${UBUNTU_VERSION}/ubuntu-${UBUNTU_VERSION}-desktop-amd64.iso
fi
topic "Installing basic Ubuntu disk image..."
echo "Follow the Ubuntu installer and close the window when finished."
qemu-system-x86_64 -hda disk.img -cdrom ubuntu-${UBUNTU_VERSION}-desktop-amd64.iso -boot d
#topic "Mounting disk.img on a loop device..."
#loop_device=$(losetup --partscan --show --find binary.img)
#mount /dev/${loop_device}
