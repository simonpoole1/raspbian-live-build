# TODO

I'm not currently working on improving raspbian-live-build, but I'd welcome patches from anyone who wants to contribute.  This 'to do' list is a list of ideas for useful features that people might want to contribute, rather than a list of planned development.

1. Make `/` (the root directory) persistent, so that installed packages and updates persist across reboots.
2. Auto-detect the WiPi USB-wifi adapter.
3. Apply the latest rpi-firmware updates (but looks like these might not have aufs support)
4. `shutdown -r now` currently says "remove disc from tray, press ENTER to continue" - it blocks until you press enter on the pi.
5. Get it working in QEMU emulator for faster dev cycle
