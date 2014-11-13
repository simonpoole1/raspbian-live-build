#!/bin/sh

BUILD_LOG := build.log

.PHONY: clean dist-clean config

all: config pi-minimal.img


# RPI requires fat32 for boot partition
config:
	[ -e build ] || mkdir build
	cd build && \
	env LB_BOOTSTRAP_INCLUDE="apt-transport-https gnupg" \
		lb config \
			--apt-indices none \
			--apt-secure false \
			--apt-source-archives false \
			--architectures armhf \
			--archive-areas 'main firmware non-free' \
			--binary-filesystem fat32 \
			--binary-images hdd \
			--bootappend-live "boot=live config hostname=pi username=pi" \
			--bootstrap-flavour minimal \
			--bootstrap-qemu-arch armhf \
			--bootstrap-qemu-static /usr/bin/qemu-arm-static \
			--chroot-filesystem squashfs \
			--compression gzip \
			--distribution wheezy \
			--firmware-binary false \
			--firmware-chroot false \
			--gzip-options '-9 --rsyncable' \
			--hdd-size 512 \
			--initramfs live-boot \
			--linux-flavours rpi \
			--mirror-bootstrap "http://archive.raspbian.org/raspbian" \
			--mirror-binary "http://archive.raspbian.org/raspbian" \
			--mode debian \
			--parent-mirror-bootstrap "http://archive.raspbian.org/raspbian" \
			--parent-mirror-binary "http://archive.raspbian.org/raspbian" \
			--security false \
			--system live
	cp -rf config build/

build/binary.img:
	( cd build && sudo lb build ) 2>&1 | tee $(BUILD_LOG)

pi-minimal.img: build/binary.img
	cp build/binary.img ./pi-minimal-wip.img
	parted -s pi-minimal-wip.img set 1 lba on
	mv pi-minimal-wip.img pi-minimal.img

dist-clean:
	-sudo rm -rf build

clean:
	-[ -e build ] && cd build && sudo lb clean
	-sudo rm -rf build/config
	-rm -f $(BUILD_LOG)

remake-img: remake-binary-img pi-minimal.img

remake-binary-img:
	sudo mv build/binary.img build/chroot/binary.img
	sudo rm -f build/.build/binary_hdd
	cd build && sudo lb binary_hdd

