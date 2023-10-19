#!/bin/bash

# Check if the user is root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as the root user. Please run it with administrator privileges."
    exit 1
fi

# Information message
echo "This script will help you create a customized Windows 10 ISO with VirtIO drivers."
echo "Make sure you have downloaded the official Windows 10 ISO from Microsoft's website:"
echo "https://www.microsoft.com/en-us/software-download/windows10"
echo "Rename the file to 'Win10.iso' and place it in the same folder as this script."
echo "Press Enter to continue or Ctrl+C to cancel."
read

# Check if the script is running in the same folder as the Windows 10 ISO
if [ -f "Win10.iso" ]; then
    ISO_PATH="./Win10.iso"
else
    read -p "Please provide the location of the downloaded Windows 10 ISO: " ISO_PATH
fi

# Check if the Windows 10 ISO exists at the provided location
if [ ! -f "$ISO_PATH" ]; then
    echo "The Windows 10 ISO was not found at the provided location."
    exit 1
fi

# Download Virtio ISO
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso -O Virtio.iso

# Create a temporary folder
temp_dir=$(mktemp -d)
mkdir windows
mkdir drivers

# Mount the Windows 10 ISO
mount -o loop "$ISO_PATH" "$temp_dir"
cp -r "$temp_dir"/* windows/
umount "$temp_dir"

# Mount the Virtio ISO
mount -o loop Virtio.iso "$temp_dir"
cp -r "$temp_dir"/* drivers/
umount "$temp_dir"

# Modify the boot.wim file
wimmountrw windows/sources/boot.wim 1 "$temp_dir"
cp -r drivers "$temp_dir/"
wimunmount --commit "$temp_dir"
wimmountrw windows/sources/boot.wim 2 "$temp_dir"
cp -r drivers "$temp_dir/"
wimunmount --commit "$temp_dir"

# Cleanup
rm -rf "$temp_dir" drivers Virtio.iso

# Modify disk partitions
read -p "Enter the disk name (e.g., /dev/sdX): " disk

# Check if the entered disk is valid
if [ ! -b "$disk" ]; then
  echo "The entered disk is not valid."
  exit 1
fi

# Delete all partitions on the disk
fdisk "$disk" <<EOF
p
d
1
w
EOF

# Format the disk as NTFS
mkfs.ntfs -f "$disk"

# Create a mount point directory (if it doesn't exist)
mount_point="/mnt/ntfs_disk"
mkdir -p "$mount_point"

# Mount the NTFS partition
mount "$disk" "$mount_point"

echo "The disk has been formatted as NTFS and mounted at $mount_point."
echo "Now you can copy files to this location."

# Copy the Windows 10 files to the disk
cp -r windows/* "$mount_point"

# Configure Grub to add Windows 10 to the boot menu
entry_content='menuentry "Windows 10 Ready" {
    insmod ntfs
    set root=(hd1,gpt1)
    chainloader (hd1,gpt1)/efi/boot/bootx64.efi
}'

# Check if the content already exists in the Grub configuration file
if ! grep -q "Windows 10 Ready" /etc/grub.d/40_custom; then
    echo "$entry_content" | sudo tee -a /etc/grub.d/40_custom
fi

# Update Grub
update-grub

# Unmount the NTFS partition
umount "$mount_point"

# Cleanup
rm -rf windows

echo "The Windows 10 ISO has been successfully modified and prepared for installation."
echo "You can now boot from the disk and install Windows 10."
echo "Don't forget to select the 'Windows 10 Ready' option from the Grub boot menu."
echo "Make sure to install the VirtIO drivers when prompted."
echo "Select them from the disk at the drivers folder inside the Windows 10 ISO."
echo "Make sure to select the SSD disk as the installation location."
echo "Press Enter to reboot the system or Ctrl+C to cancel."
read && reboot 
