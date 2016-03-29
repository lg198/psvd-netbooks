mkdir loopdir
mount -o loop deb*.iso loopdir
mkdir cdir
rsync -a -H --exclude=TRANS.TBL loopdir/ cdir
umount loopdir

mkdir irmod
cd irmod
gzip -d < ../cdir/install.386/2.6/initrd.gz | cpio --extract --verbose --make-directories --no-absolute-filenames
cp ../preseed.cfg preseed.cfg
find . | cpio -H newc --create --verbose | gzip -9 > ../cdir/install/2.6/initrd.gz
cd ../
rm -fr irmod/

genisoimage -o debian_patched.iso -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/boot.cat ./cdir
