# UBOOTWPDA config http://www.twpda.com/2013/08/uboot-code.html
# NOTE: This file's length should under 988 bytes
# bootargs(old): root=8:1 means sda1, sda2 8:2, sdb1 8:17, sdb2 8:18
# bootargs(new): root=/dev/sda2
# bootcmd: 0:1 first part, 0:2 2nd part
# usbcfg: 0:internal, 1:external

# boot settings for internal USB sda1:kernel+uboot.sh sda2:ext4
setenv bootargs 'console=ttyAS0,115200 rootdelay=0 root=/dev/sda3 rootfstype=ext4 rw rootflags=data=journal nwhwconf=device:eth0,hwaddr:10:08:E2:12:06:BD phyaddr:0,watchdog:5000 mem=256M bigphysarea=2048'
setenv bootcmd 'usbcfg 0; usb start; usb info; usb part; fatload usb 0:1 80000000 vmlinux.ub; bootm 80000000'
#setenv bootcmd 'ext2load usb 0:2 80000000 boot/vmlinux.ub; bootm 80000000'
