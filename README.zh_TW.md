# sh5twbox-multiboot 網樂通多重開機 (中文)

本專案示範 網樂通 上多重開機設定, 主要原理是透過 UBOOTWPDA 
及一個簡單的批次檔案(mboot).

我們可以透過 mboot 及本專案的修正批次檔來測試各個跑在網樂通上面的作業系統:
[sh4twbox][sh4twbox], [xbmc][xbmc], [debian][debian], [Fedora][fedora] 
及 [Arch][arch].

若網樂通有插外部 USB, 那麼在這份文件中 sda 可能是 sdb, 你可以用 `fdisk -l`
指令檢查.(這是BOOTWPDA已知問題)

---
## 選取開機區方式

### 連結開機分割區
你可以用 `fdisk -l` 找出要使用 sda1 或 sdb1.
    # mount /dev/sda1 /boot
    ## 或
    # mount /dev/sdb1 /boot
    ## 或者你已經設定好 /etc/fstab, 只要
    # mount /boot
接著到開機區
    # cd /boot

### 執行選單

    # ./mboot     <--- 進入選單選擇開機系統
    2015/07/10 14:53:36 2_xbmc   <--- 顯示目前開機的系統及上一次設定時間
    ==Available Boot OS==
    1_recovery  2_xbmc      3_debian    6_sh4twbox  7_fedora    8_arch  
    === enter the number:1  <---輸入數字切到所需系統(recovery)  
    ... [ 略 ] ... <--- 這裡是一些除錯訊息
    + cat ../uboot.sh
    ... [ 略 ] ...  <-- 顯示開機使用的參數
    + set +x
    Press [Enter] to reboot  <--- 按下 Enter 就會重開機

---
## 增加開機區方式

假設已經安裝了新作業系統(如: buildroot)在其中一個分割區(如: /dev/sda9).  接著重新開機進入恢復分割區(recovery).

### 將相關分割驅連結

將 SDX 以 sda1 或 sdb1 取代.

    # mkdir -p /mnt/sda9
    # mount /dev/sda9 /mnt/src
    # mount /dev/SDX /boot
    # cd /boot

使用命名規則 <分割區編號>\_<分割區作業系統名稱>. 將 KERNEL 更換為 vmlinux.ub 或 uImage...

    # mkdir -p boot/9_buildroot
    # vi boot/9_buildroot/uboot.sh
    # cp /mnt/src/KERNEL boot/9_buildroot
    
    # cd /mnt/src
    # mkdir -p boot
    # echo "/dev/SDX /boot auto defaults,noauto 0 0" >> /etc/fstab

--- 
## 安裝 mboot 批次檔方式

    # mkdir -p /mnt/sda1
    # mount /dev/sda1 /mnt/sda1
    # cd /mnt/sda1  # 安裝到 recovery 分割區
    
    ## wget https://raw.githubusercontent.com/dlintw/sh4twbox-multiboot/master/mboot
    ## because busybox's wget can not get https, we use dropbox.
    # wget http://www.dropbox.com/s/7pfdvzks3h8clwc/mboot 

    # chmod +x mboot
    
# 安裝多個作業系統範例

    * 參見 http://www.twpda.com/2013/09/sh4twbox-07.html to boot into sh4twbox.
    * 參見e EXAMPLE.md

[//]: # ( vim:set et sw=4 ts=4 ai: )
