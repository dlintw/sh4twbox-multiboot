# Example for multiple boot

Here is a full steps from a original [NextVOD][nextvod] to multiple OS.

---
## Step 1. Update Das U-boot

* [Developer's Chinese document][sh4twbox]
* [The same section on Han Yu's XBMC@NextVOD][xbmc]

---
## Step 2. Boot into sh4twbox and create partitions

Setup FAT32 type partition and put kernels in it will gain the fast boot speed.
But, use ext3 type will be stable. (Because UBOOTWPDA still contains bugs 
for reading FAT).

For example:

    # fdisk /dev/sda
    # fdisk -l   # show the result

    Disk /dev/sda: 8027 MB, 8027897856 bytes
    247 heads, 62 sectors/track, 1023 cylinders
    Units = cylinders of 15314 * 512 = 7840768 bytes

       Device Boot      Start         End      Blocks  Id System
    /dev/sda1    +256M      1          34      260307   6 FAT16  
    /dev/sda2    +256M     35          68      260338  83 Linux
    /dev/sda3    +1024M    69         200     1010724  83 Linux
    /dev/sda4             201        1023     6301711   5 Extended
    /dev/sda5    +256M    201         234      260307  82 Linux swap
    /dev/sda6    +256M    235         268      260307  83 Linux
    /dev/sda7    +1024M   269         400     1010693  83 Linux
    /dev/sda8    +1024M   401         532     1010693  83 Linux
    /dev/sda9             533        1023     3759556  83 Linux

    ## 1_recovery  2_xbmc 3_debian 6_sh4twbox  7_fedora 8_arch    

    ## format partitions
    # mkfs.vfat -L BOOT /dev/sda1
    ## mkfs.ext3 -I128 -L BOOT /dev/sda1  # or use ext3

    # mkswap -L SWAP /dev/sda5

    # for i in 2 3 6 7 8 9 ; do mkfs.ext4 -I128 /dev/sda$i ; done
    ## or specify every label
    ## mkfs.ext4 -I128 -L xbmc     /dev/sda2 
    ## mkfs.ext4 -I128 -L debian   /dev/sda3 
    ## mkfs.ext4 -I128 -L sh4twbox /dev/sda6 
    ## mkfs.ext4 -I128 -L fedora   /dev/sda7 
    ## mkfs.ext4 -I128 -L arch     /dev/sda8 

---
## Step 3. Install sh4twbox as recovery OS in first partition

On Step 1. you may have already a workable recovery USB stick could plug on
external USB slot. Just copy the files into the first partition. 
Assume (sda is the internal partition, sdb is the external partition)

### Install mboot

    # mount /dev/sda1 /mnt/sda1
    # mount /dev/sdb1 /mnt/sdb1
    # cd /mnt/sda1

    ## wget https://raw.githubusercontent.com/dlintw/sh4twbox-multiboot/master/mboot
    ## because busybox's wget can not get https, we use dropbox.
    # wget http://www.dropbox.com/s/7pfdvzks3h8clwc/mboot 

### Install Recovery OS


    # mkdir -p boot/1_recovery
    # cd boot/1_recovery
    # cp /mnt/sdb1/initrd.ub  .
    # vi uboot.sh   

 * [uboot.sh content](http://github.com/dlintw/sh4twbox-multiboot/example/boot/1_recovery)

---
## Step 4. Install XBMC for video/audio play on HDMI TV

Boot to recovery OS and 
Get install file from Han Yu's development [site](http://chinghanyu.twbbs.org/redmine/projects/open-duckbox-project-on-sh4-platform/files).


 * [XBMC@NextVOD Document](http://chinghanyu.twbbs.org/redmine/projects/open-duckbox-project-on-sh4-platform/wiki)
 * [uboot.sh content](http://github.com/dlintw/sh4twbox-multiboot/example/boot/2_xbmc)
 * [useful patches](http://github.com/dlintw/sh4twbox-multiboot/example/patches/xbmc)
 * [setup tutorial](http://samantw.com/nextvod-xbmc-addons-chinese/)

Commands:

    # mount /dev/sda2 /mnt/sda2
    # cd /mnt/sda2
    # wget http://chinghanyu.twbbs.org/redmine/attachments/download/97/nextvod-pdk7105-215-xbmc-12.3-Frodo-20150209.tar.xz
    # tar xf nextvod-pdk7105-215-xbmc-12.3-Frodo-20150209.tar.xz

    # cd /mnt/sda1
    # mkdir -p boot/2_xbmc
    # cd boot/2_xbmc
    # cp /mnt/sda2/boot/uImage .
    # vi uboot.sh   


After patch, you'll see English menu on first reboot.
Reboot it for two more times, you'll see preset Chinese menu.

You could login by telnet after reboot.

---
## Step 5. Install debian for more packages support

Debian require 415M disk space for installation.

 * [Official site](http://ftp.yzu.edu.tw/linux/debian-sh4-for-nextvod/handbook.php)
 * [uboot.sh](http://github.com/dlintw/sh4twbox-multiboot/example/boot/3_debian)

Commands:

    # mount /dev/sda3 /mnt/mnt_system  # trick to extract old NextVOD format
    # cd /mnt/mnt_system  
    # wget http://ftp.yzu.edu.tw/linux/debian-sh4-for-nextvod/download/target.tgz

    # cd ..
    # tar xf target.tgz

    # cd /mnt/sda1
    # mkdir -p boot/3_debian
    # cd boot/3_debian
    # cp /mnt/mnt_system/vmlinux.ub . 
    # vi uboot.sh   

You could login by ssh after reboot. (user: *root* password *root*)

---
## Step 6. Install sh4twbox for study minimal OS

Download from sh4twbox google code site

 * [uboot.sh](http://github.com/dlintw/sh4twbox-multiboot/example/boot/6_sh4twbox)
 * [useful patches](http://github.com/dlintw/sh4twbox-multiboot/example/patches/sh4twbox)

Commands:

    # mount /dev/sda6 /mnt/sda6
    # cd /mnt/sda6
    # wget http://sh4twbox.googlecode.com/files/sh4twbox-0.9.2.txz
    # tar xf sh4twbox-0.9.2.txz

    # cd /mnt/sda1
    # mkdir -p boot/6_sh4twbox
    # cd boot/6_sh4twbox
    # cp /mnt/sda6/vmlinux.ub .
    # vi uboot.sh   

You could login by ssh after reboot. (user: *root* password *twpdatwpda*)

---
## Step 7. Install Fedora for Redhat/Centos commands

Download from sh4twbox google code site (525M disk space required)

 * [uboot.sh](http://github.com/dlintw/sh4twbox-multiboot/example/boot/7_fedora)

Commands:

    # mount /dev/sda7 /mnt/mnt_system  # trick to extract old NextVOD format
    # cd /mnt/mnt_system  
    # wget http://sh4twbox.googlecode.com/files/target.fc9.20130725.tgz

    # cd ..
    # tar xf target.fc9.20130725.tgz

    # cd /mnt/sda1
    # mkdir -p boot/7_fedora
    # cd boot/7_fedora
    # cp /mnt/sda6/vmlinux.ub .   # NOTE: use sh4twbox's kernel for ext4 support
    # vi uboot.sh   

You could login by ssh after reboot. (user: *root* password *la.t28.net*)

---
## Step 8. Install Fedora for Redhat/Centos commands

Download from sh4twbox google code site (525M disk space required)

 * [uboot.sh](http://github.com/dlintw/sh4twbox-multiboot/example/boot/7_fedora)

Commands:

    # mount /dev/sda7 /mnt/mnt_system  # trick to extract old NextVOD format
    # cd /mnt/mnt_system  
    # wget http://sh4twbox.googlecode.com/files/target.fc9.20130725.tgz

    # cd ..
    # tar xf target.fc9.20130725.tgz

    # cd /mnt/sda1
    # mkdir -p boot/7_fedora
    # cd boot/7_fedora
    # cp /mnt/sda6/vmlinux.ub .   # NOTE: use sh4twbox's kernel for ext4 support
    # vi uboot.sh   

You could login by ssh after reboot. (user: *root* password *la.t28.net*)

---
## Step 9. Install Arch for build your own package from AUR

Download from sh4twbox google code site (339M disk space required)

 * [uboot.sh](http://github.com/dlintw/sh4twbox-multiboot/example/boot/8_arch)

Commands:

    # mount /dev/sda8 /mnt/sda8
    # cd /mnt/sda8
    # wget http://sh4twbox.googlecode.com/files/arch.20131215.txz  
    # tar xf arch.20131215.txz  

    # cd /mnt/sda1
    # mkdir -p boot/8_arch
    # cd boot/8_arch
    # cp /mnt/sda8/boot/vmlinux.ub .
    # vi uboot.sh   

You could login by ssh after reboot. (user: *root* password *twpdatwpda*)

[nextvod]: https://zh.wikipedia.org/wiki/%E7%B6%B2%E6%A8%82%E9%80%9A
[sh4twbox]: http://www.twpda.com/2013/09/sh4twbox-07.html
[xbmc]: http://chinghanyu.twbbs.org/redmine/projects/open-duckbox-project-on-sh4-platform/wiki
[debian]: http://ftp.yzu.edu.tw/linux/debian-sh4-for-nextvod
[fedora]: https://code.google.com/p/sh4twbox/downloads/detail?name=target.fc9.20130725.tgz&can=2&q=fedora#makechanges
[arch]: http://www.twpda.com/2013/04/arch-linux.html

[//]: # ( vim:set et sw=4 ts=4 ai: )
