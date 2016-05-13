# Required packages: syslinux-utils
mkdir loopdir
sudo mount -o loop xubuntu-*.iso loopdir
mkdir isofiles
rsync -a -H --exclude=TRANS.TBL loopdir/ isofiles/
sudo umount loopdir
chmod u+w isofiles

sudo cp preseed.cfg isofiles/preseed.cfg
sudo cp txt.cfg isofiles/isolinux/txt.cfg

sudo genisoimage -o xubuntu_patched.iso -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/boot.cat ./isofiles

sudo isohybrid xubuntu_patched.iso

sudo rm -rf loopdir
sudo rm -rf isofiles
