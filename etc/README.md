# Linux system config files

These files are symlinked into `/etc/` by `make etc` (Linux only). They are
hardware- and Linux-specific and have no effect on macOS.

| File | Purpose |
|---|---|
| `modprobe.d/xps13-9360.conf` | Kernel module options tuned for the Dell XPS 13 9360. Only relevant on that laptop. |
| `systemd/system/syncthing@.service` | systemd unit template for running Syncthing per-user. Used by the (currently disabled) Syncthing target in the top-level Makefile. |
| `X11/xorg.conf.d/50-synaptics-clickpad.conf` | X11 input config for synaptics clickpad-style touchpads. Only relevant if you run X11 (not Wayland) and use a synaptics-driven touchpad. |
