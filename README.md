# raspbian-live-build

Builds custom Raspbian disk images for the Raspberry PI using Debian's
live-build tool and the raspian.org/raspberrypi.org APT repositories.

This build process has been tested under Ubuntu 14.04 with live-build 3.0~a57-1
 (which is the default version available from the Ubuntu 14.04 repository)

## Prerequisites:
```sh
sudo apt-get install qemu-user-static qemu-utils qemu-system-arm
sudo apt-get install live-build debootstrap
```

## Build
To run a build:
```sh
make dist-clean
make
ls -lh pi-minimal.img
```

The image generated is called "pi-minimal.img" and will appear in the same
folder as the Makefile.  The build can take a while to run (e.g. 30 mins)

## Install
To install on your SD card
```sh
sudo apt-get install pv
pv pi-minimal.img | sudo dd of=/dev/path-to-your-sd-card bs=16M
```

## Troubleshooting the build

### File folder in use
If you get errors during the build along the lines of not being able to unmount
or remove a folder because it's in use, that's may be because something in your
system (e.g. udisks, Nautilus etc) has detected the disk-image being built and
auto-mounted it.

You may be able to fix this by preventing the automounting.  E.g. maybe this
will help:
```sh
sudo cat >/etc/udev/rules.d/99-udisks2.rules <<EOF
ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="loop*", ENV{UDISKS_IGNORE}="1"
EOF
sudo udevadm control --reload
```

Or you may be able to fix it by adding a sleep into the build wherever it's
breaking.  E.g. in `/usr/lib/live/build/lb_binary_hdd` add a "sleep 1" before the
line that says `${LB_ROOT_COMMAND} umount chroot/binary.tmp`.

