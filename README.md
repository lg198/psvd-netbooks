# pvsd-netbooks

This outlines the process of installing the PVSD Netbook image onto a single netbook.

## Prereqs

The images **must** be generated on a Linux computer. Sorry about that.

You'll need to have `git` installed on your system, as well as `curl, rsync, genisoimage, pv`. You must also install the `syslinux` and `syslinux-utils` packages. Install those by executing the following command:
```
sudo apt-get install git curl rsync genisoimage pv syslinux syslinux-utils
```

## Clone the git repository

The install scripts are stored in a git repository. Run `git clone https://github.com/lg198/pvsd-netbooks.git` to clone it into a folder named `pvsd-netbooks`.

## Create the USB

You'll need an empty USB stick. It should be at least 2 GB for safety.

### Find the USB's name

Run `lsblk -d` in the command prompt. You will see an output similar to the following:
```
NAME MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda    8:0    0 698.7G  0 disk 
sdb    8:16   1   7.5G  0 disk 
```
Each `name` represents a disk (USB stick, hard drive, or, God forbid, a floppy disk). Find the one that is the USB stick by finding the disk with the appropriate size (hint: it won't be sda). Remember the name of your USB stick.

### Generate the ISO

Inside the `pvsd-netbooks` directory, run `./download_image.sh`. It might take a while.

Run `sudo ./patch.sh`. It will generate a lot of output.

Run `sudo pv xubuntu_patched | sudo dd of=/dev/? bs=120M`, replacing `?` with the USB name (found above). **WARNING: Don't use /dev/sda... you'll overwrite your hard drive!**

If all goes well, you should have a bootable USB drive!

### To the netbooks

First, make sure that the netbook is charging and is connected to the internet via an ethernet cable. Next, turn it on and start spamming `F12` until the boot menu appears. From there, enable USB boot in the BIOS. _Make sure hard drive boot is above the USB boot in the boot order!_ Then restart, spam `F12`, select the USB boot option.

Xubuntu will install. When it is finished, a dialog will appear. Press okay (it might freeze up, but that's okay), and it will restart. Then it will instruct you to remove the USB stick and press enter. Follow its orders, or else!

When the login screen appears, enter `ladmin`'s password (currently `fluffycats`). Once you log into the account, press <Windows Key - T> to open a terminal. Enter the following commands (you will be prompted to enter the `ladmin` password again):
```
sudo apt-get install curl
sudo curl -L -o postinstall.sh https://git.io/vw4nY
sudo chmod +x postinstall.sh
sudo ./postinstall.sh
```
The last command will run the post install script, which will prompt you for three things:

1. The computer hostname - There is a sticker on the front of each netbook with a large code on it (starting with `PVHS-`). Enter the large code from the sticker **EXACTLY** as it appears on said sticker. If you see something that looks like an `O` (the letter Oh), it is a **ZERO**!
2. The password for macjoin@PVSD.ORG - Have Mr. P enter that for you
3. The PV-Mobile password - Have Mr. P enter that for you... no peeking!

After the wireless internet is configured, the script will instruct you to press enter when the connection is established. You will see a little notification with a wifi symbol in the top right of the screen. When that appears, it is safe to press enter and continue.

The script will restart the computer. If all goes well, the PVSD logo should be visible when it reboots, and network accounts will be available when the login screen appears.
