# rpi-live-build

Builds Raspberry PI disk images using debian's live-build tool and the Raspian
apt repository.  This is for the RACHEL project (http://rachel.worldpossible.org/),
hence some of the config is currently RACHEL-specific.

Prerequisites:
```sh
    sudo apt-get install qemu-user-static live-build debootstrap qemu-utils \
        qemu-system-arm
```

To run a build:
```sh
    make clean
    make
```

To boot the image in QEMU emulator, you need to download kernel-qemu from
http://xecdesign.com/downloads/linux-qemu/kernel-qemu .  Then run:
```sh
    qemu-system-arm \
        -kernel path/to/kernel-qemu \
        -initrd build/binary/live/initrd.img-* \
        -cpu arm1176 \
        -m 256 \
        -M versatilepb \
        -no-reboot \
        -serial stdio \
        -append "panic=1 root=/dev/sda1 boot=live" \
        -hda build/binary.img
```

