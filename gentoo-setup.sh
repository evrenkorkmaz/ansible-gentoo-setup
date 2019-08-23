# Author : Evren Korkmaz
# Gentoo Setup Script >> Gentoo amd64 (x86-64) 
# This Script fot the automaticly setup the gentoo os.
# This script automaticly select a mirror in Turkey. If u want to change, check line 40.
# Host name default is "evren". (line 99)
# Script create a user. This user name is "evren" and password: "userrpasswd". Root password is : "rootpasswd". (line: 114-115-116)

#! /bin/bash

# parted operation
parted /dev/sda --script mklabel gpt
parted /dev/sda --script unit mib
parted /dev/sda --script mkpart primary 1 3
parted /dev/sda --script name 1 grub
parted /dev/sda --script set 1 bios_grub on
parted /dev/sda --script mkpart primary 3 131
parted /dev/sda --script name 2 boot
parted /dev/sda --script mkpart primary 131 643
parted /dev/sda --script name 3 swap
parted /dev/sda --script mkpart primary 643 -- -1
parted /dev/sda --script name 4 rootfs
parted /dev/sda --script set 2 boot on

#create fs and mount 
mkfs.ext2 /dev/sda2
mkfs.ext4 /dev/sda4
mkswap /dev/sda3
swapon /dev/sda3
mount /dev/sda4 /mnt/gentoo

#download stage ball
wget http://distfiles.gentoo.org/releases/amd64/autobuilds/20190818T214502Z/stage3-amd64-20190818T214502Z.tar.xz -P /mnt/gentoo
cd /mnt/gentoo
tar xpvf /mnt/gentoo/stage3-* --xattrs-include='*.*' --numeric-owner

# add flag
echo MAKEOPTS='"-j2"' >> /mnt/gentoo/etc/portage/make.conf

#mirror select 
mirrorselect -i -c TURKEY  >> /mnt/gentoo/etc/portage/make.conf
mkdir --parents /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

#copy dns info
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

#prepare for new environment
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev

#new environment
chroot /mnt/gentoo /bin/bash << END

#mount /dev/sda2
mount /dev/sda2 /boot

#portage
emerge-webrsync

#select profile
eselect profile list
eselect profile set 1

#update @wold 
emerge --verbose --update --deep --newuse @world

#time zone
echo "Europe/Istanbul" > /etc/timezone
emerge --config sys-libs/timezone-data

# update locale.gen
echo en_US ISO-8859-1 >> /etc/locale.gen
echo en_US.UTF-8 UTF-8  >> /etc/locale.gen

eselect locale list
eselect locale set 5
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"

#parion label uuid
echo "/dev/sda2   /boot        ext2    defaults,noatime     0 2" >> /etc/fstab
echo "/dev/sda3   none         swap    sw                   0 0" >> /etc/fstab
echo "/dev/sda4   /            ext4    noatime              0 1" >> /etc/fstab
echo "/dev/cdrom  /mnt/cdrom   auto    noauto,user          0 0" >> /etc/fstab


#kernel config
emerge sys-kernel/gentoo-sources

#use genkernel 
echo "sys-apps/util-linux static-libs" >> /etc/portage/package.use/custom
mkdir /etc/portage/package.license
echo "sys-kernel/linux-firmware linux-fw-redistributable no-source-code" >> /etc/portage/package.license/custom
emerge sys-kernel/genkernel
genkernel all

echo hostname='"evren"' > /etc/conf.d/hostname
#network config
emerge --noreplace net-misc/netifrc


#logger
emerge app-admin/sysklogd
rc-update add sysklogd default


#GRUB
emerge --verbose sys-boot/grub:2
emerge sys-boot/grub:2
emerge --update --newuse --verbose sys-boot/grub:2

echo "root:rootpasswd" | chpasswd 
useradd -m -G users,wheel,audio -s /bin/bash evren
echo "evren:userpasswd" | chpasswd

grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

END
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -R /mnt/gentoo
reboot
