# Required packages: syslinux-utils
mkdir loopdir
sudo mount -o loop debian-8*.iso loopdir
mkdir isofiles
rsync -a -H --exclude=TRANS.TBL loopdir/ isofiles/
sudo umount loopdir
chmod u+w isofiles

mkdir workspace
cd workspace
gzip -d < ../isofiles/install.386/initrd.gz | cpio --extract --verbose --make-directories --no-absolute-filenames
cp ../preseed.cfg preseed.cfg
chmod u+w ../isofiles/install.386/initrd.gz
find . | sudo cpio -H newc --create --verbose | sudo gzip -9 > ../isofiles/install.386/initrd.gz
cd ../

sudo genisoimage -o debian_patched.iso -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/boot.cat ./isofiles

sudo isohybrid debian_patched.iso

sudo rm -rf loopdir
sudo rm -rf workspace
sudo rm -rf isofiles
