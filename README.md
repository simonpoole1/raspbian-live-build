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

## What's included
Currently very little - just the bare minimum you need to acquire an IP address
via DHCP, login (username: pi, password: pi) and apt-get more stuff!

E.g. `sudo apt-get install apache2` will download, install and run a web-server
which should be immediately visible on your network. But currently nothing you
do will persist across a reboot.  Every time you reboot you'll be back to a
vanilla system.

## Customising the build
You can add more packages to the build by specifying them in the package-list
files in `config/package-lists/` - just make sure any config files you add in
there are named `*.list.chroot`.

You can add additional repositories in config/archives - just be sure to follow
the pattern of the ones already specified and don't forget to download the GPG
key.

## Troubleshooting the build

### File folder in use
If you get errors during the build along the lines of not being able to unmount
or remove a folder because it's in use, that's may be because something in your
system (e.g. udisks, Nautilus etc) has detected the disk-image being built and
has auto-mounted it or is querying its partition table.

You may be able to fix this by adding a sleep into the build wherever it's
breaking.  E.g. in `/usr/lib/live/build/lb_binary_hdd` add a `sleep 1` before
the line that says `${LB_ROOT_COMMAND} umount chroot/binary.tmp`.

## Running in the QEMU emulator

QEMU lets you test your image in an emulator, to save you having to repeatedly
burn test images to SD cards.  The currently release version of QEMU (Dec 2014)
is not able to emulate a Raspberry Pi, but there's a development version of it
that's partly working.  Currently networking doesn't work, and the keyboard
sometimes fails after a short period of use, but if you want to give it a go...

To build a version of QEMU that supports the Pi:
```sh
# Install build dependencies (this is for Ubuntu - you might need to change it
# to something appropriate for your system)
sudo apt-get install git build-essential \
    libglib2.0-dev libfdt-dev libgtk2.0-dev libvte-dev libusb-1.0-0-dev

# Fetch the head of the "rpi" branch from Torlus' QEMU fork
git clone --depth 0 -b rpi https://github.com/Torlus/qemu.git qemu-rpi-src
cd qemu-rpi-src

# Build QEMU. Change --prefix if you want to install to a different location
./configure --target-list="arm-softmmu,arm-linux-user,armeb-linux-user" \
    --prefix=$HOME/qemu-rpi --enable-gtk --enable-libusb
make -i
make -i install

# Create the symlink used by raspbian-live-build's qemu-run:
sudo ln -s $HOME/qemu-rpi/bin/qemu-system-arm /usr/local/bin/qemu-system-pi
```

To start the emulator with your image, make sure `/usr/local/bin` is in your
PATH and then from the raspbian-live-build folder run:
```sh
./qemu-run
```

If you want the output to appear in your console instead of in a window, use
`qemu-run -c`

