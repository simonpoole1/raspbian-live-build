# TODO

I'm not currently working on improving raspbian-live-build, but I'd welcome patches from anyone who wants to contribute.  This 'to do' list is a list of ideas for useful features that people might want to contribute, rather than a list of planned development.

1. Make `/` (the root directory) persistent, so that installed packages and updates persist across reboots.
2. Auto-detect the WiPi USB-wifi adapter.
3. Apply the latest rpi-firmware updates.
4. Get it working under the QEMU emulator - just needs the kernel modules for the right kernel version, so it can be booted with the QEMU-ready kernel from http://xecdesign.com/qemu-emulating-raspberry-pi-the-easy-way/
5. `shutdown -r now` currently says "remove disc from tray, press ENTER to continue" - it blocks until you press enter on the pi.

