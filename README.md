# sh4twbox-multiboot

This project demostrates the multi-boot setup through UBOOTWPDA and a simple
script file (mboot).

We can use mboot and this project's scripts to test multiple OS including 
[sh4twbox][sh4twbox], [xbmc][xbmc], [debian][debian], [Fedora][fedora] 
and [Arch][arch] for NextVOD.

In this document sda maybe sdb if you plug-in external USB on NextVOD.
You can use `fdisk -l` to check it.(This is a known issue of UBOOTWPDA)

---
## Usage for choose boot partition

### mount boot partition
You can run `fdisk -l` to check use sda1 or sdb1.
    # mount /dev/sda1 /boot
    ## or 
    # mount /mnt/sdb1 /boot
    ## or if you have setup /etc/fstab, just
    # mount /boot
Then
    # cd /boot

### Run the menu to choose next boot menu

    # ./mboot     <--- enter the menu for boot 
    2015/07/10 14:53:36 2_xbmc   <--- current boot partition and its setup time
    ==Available Boot OS==
    1_recovery  2_xbmc      3_debian    6_sh4twbox  7_fedora    8_arch  
    === enter the number:1  <--- enter the partition number (eg. recovery)
    ... [ omit ] ... <--- display debug information
    + cat ../uboot.sh
    ... [ omit ] ... <--- display the boot parameters    
    + set +x
    Press [Enter] to reboot  <--- press enter will reboot to your new setting 

---
## Usage for add a new boot partition

We assume you have installed your OS (eg. buildroot) on one partition (eg. /dev/sda9). And boot to recovery partition.

### mount related partitions
Replace the SDX with sda1 or sdb1.
    # mkdir -p /mnt/sda9
    # mount /dev/sda9 /mnt/src
    # mount /dev/SDX /boot
    # cd /boot

### create new directory
It should following naming rule <partition\_number>\_<partition\_name>. Replace the KERNEL with vmlinux.ub or uImage...

    # mkdir -p boot/9_buildroot     
    # vi boot/9_buildroot/uboot.sh
    # cp /mnt/src/KERNEL boot/9_buildroot
    
    # cd /mnt/src
    # mkdir -p boot
    # echo "/dev/SDX /boot auto defaults,noauto 0 0" >> /etc/fstab
    
---
## Installation for mboot script

    # mkdir -p /mnt/sda1
    # mount /dev/sda1 /mnt/sda1
    # cd /mnt/sda1  # to recovery partition

    ## wget https://raw.githubusercontent.com/dlintw/sh4twbox-multiboot/master/mboot
    ## because busybox's wget can not get https, we use dropbox's space.
    # wget http://www.dropbox.com/s/7pfdvzks3h8clwc/mboot 

    # chmod +x mboot
   
---
## Multiple os boot installation example

 * See the installation guide on [sh4twbox][sh4twbox].
 * See [EXAMPLE.md](/EXAMPLE.md)

[nextvod]: https://zh.wikipedia.org/wiki/%E7%B6%B2%E6%A8%82%E9%80%9A
[sh4twbox]: http://www.twpda.com/2013/09/sh4twbox-07.html
[xbmc]: http://chinghanyu.twbbs.org/redmine/projects/open-duckbox-project-on-sh4-platform/wiki
[debian]: http://ftp.yzu.edu.tw/linux/debian-sh4-for-nextvod
[fedora]: https://code.google.com/p/sh4twbox/downloads/detail?name=target.fc9.20130725.tgz&can=2&q=fedora#makechanges
[arch]: http://www.twpda.com/2013/04/arch-linux.html

[//]: # ( vim:set et sw=4 ts=4 ai: )
