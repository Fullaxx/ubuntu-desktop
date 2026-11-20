# Extra privileges (docker run options)

The image runs with Docker's default restrictions: no host devices, a reduced set of capabilities, and Docker's AppArmor and seccomp profiles.
Some programs need one of these loosened. Each option below says what it gives the container, what it's for, and what it costs. Add only the ones you need.

Tested on an Ubuntu 24.04 host (kernel 6.8, AppArmor) with Docker 29.9.2, as root (the default session) and as a `VNCUSERMAP` user.

- [Quick reference](#quick-reference)
- [Sound](#sound)
- [FUSE (sshfs and other FUSE filesystems)](#fuse-sshfs-and-other-fuse-filesystems)
- [Privileged mode (FlatPak, VeraCrypt)](#privileged-mode-flatpak-veracrypt)
- [GTK images and bubblewrap](#gtk-images-and-bubblewrap)
- [Not needed](#not-needed)

## Quick reference
| For | docker run options | Gives the container |
|---|---|---|
| Sound | `--device /dev/snd` | the host's sound devices |
| FUSE: sshfs and other FUSE filesystems | `--device /dev/fuse --cap-add SYS_ADMIN --security-opt apparmor=unconfined` | FUSE mounts. Root in the container can also mount other filesystems, and Docker's AppArmor profile is off |
| FlatPak, VeraCrypt volumes | `--privileged` | every host device and capability, with no AppArmor or seccomp profile |

Web browser tabs crashing? See [troubleshooting/WEB_BROWSERS.md](troubleshooting/WEB_BROWSERS.md).

## Sound
Passthrough for audio devices inside the container
```
--device /dev/snd
```
`--privileged` works too, but gives far more (see [Privileged mode](#privileged-mode-flatpak-veracrypt)).

## FUSE (sshfs and other FUSE filesystems)
Allow FUSE mounts, such as sshfs, inside the container
```
--device /dev/fuse --cap-add SYS_ADMIN --security-opt apparmor=unconfined
```
Run the image with FUSE
```
docker run -d -p 127.0.0.1:5901:5901 --device /dev/fuse --cap-add SYS_ADMIN --security-opt apparmor=unconfined ghcr.io/fullaxx/ubuntu-desktop
```
sshfs isn't in the image. Install it from a terminal in the desktop, then mount and unmount
```
sudo apt-get update && sudo apt-get install -y sshfs
mkdir -p ~/remote
sshfs user@host:/path ~/remote
fusermount3 -u ~/remote
```
- **Why each option:**
  - `--device /dev/fuse`: the FUSE device. Without it, `fuse: device /dev/fuse not found`.
  - `--cap-add SYS_ADMIN`: the mount needs it. It also lets root in the container mount other filesystems.
  - `--security-opt apparmor=unconfined`: Docker's AppArmor profile denies every mount, FUSE included. Without it, on hosts with AppArmor (Ubuntu, Debian): `fuse: mount failed: Permission denied`. It turns AppArmor off for this container. On hosts without AppArmor it changes nothing.
- **Unmounting:** right after the first mount, the desktop may still be looking at it, and `fusermount3 -u` says `Device or resource busy`. Wait a moment and try again.
- **Tested:** sshfs mounts as root and as the desktop user.
- **The cost:** the container is less isolated from the host. Use these options only where you need FUSE.

## Privileged mode (FlatPak, VeraCrypt)
Give the container every host device and capability, with no AppArmor or seccomp profile
```
--privileged
```
- **FlatPak:** works as root and as the desktop user. `/app/scripts/gst.FP.sh` installs and runs GtkStressTesting from Flathub, about 2.5 GB with its runtime.
- **VeraCrypt:** mount volumes without the kernel's cryptographic services. The default uses the kernel's device mapper, whose new device (`/dev/mapper/veracrypt1`) doesn't appear inside the container. In the GUI that's "Do not use kernel cryptographic services" in its Preferences; from a terminal, into a mount point that exists:
  ```
  sudo mkdir -p /mnt/vc
  veracrypt --text --mount volume.hc /mnt/vc --mount-options=nokernelcrypto
  ```
  Tested as root, the default session.
- **Sound and FUSE** work here too.
- **The cost:** the container can use every device of the host. Use it only for containers you trust.

## GTK images and bubblewrap
Ubuntu 26.04's GTK programs load every image, icons included, through glycin, which decodes them in a sandbox made with bubblewrap (`bwrap`).
Before a program's first image, glycin tests that sandbox. Where the container blocks it outright, as a plain `docker run` does, glycin decodes without it and prints a harmless `WARNING: Glycin running without sandbox.`
Several of the options above let bwrap start and then fail a later step, which glycin doesn't recognize: it keeps the sandbox, every image fails to load, and GTK programs abort, though Openbox itself keeps running:
```
Failed to load /usr/share/icons/Adwaita/scalable/status/image-missing.svg: Loader process exited early with status '1'
```
The image works around it: when glycin's test fails, glycin is told so in the words it falls back on, and images load without the sandbox. Everything else that runs bwrap, glycin's real sandboxes and FlatPak included, is unchanged.

Optional: Turn the workaround off \
Default: on
```
-e BUBBLEWRAP_WORKAROUND='0'
```

| docker run options | root, without the workaround | the desktop user (`VNCUSERMAP`), without the workaround | with the workaround (the default) |
| --- | --- | --- | --- |
| none | works | works | works |
| `--device /dev/fuse --cap-add SYS_ADMIN` | GTK programs abort | GTK programs abort | works |
| `--device /dev/fuse --cap-add SYS_ADMIN --security-opt apparmor=unconfined` (FUSE) | GTK programs abort | GTK programs abort | works |
| `--privileged` (FlatPak, VeraCrypt) | works, in the sandbox | GTK programs abort | works (root keeps the sandbox) |
| `--security-opt seccomp=unconfined` | GTK programs abort | GTK programs abort | works |
| `--security-opt apparmor=unconfined` | works | works | works |

Openbox itself keeps running in every case. Other hosts give other combinations.

- **Why it fails:**
  - `--cap-add SYS_ADMIN` and `seccomp=unconfined`: Docker's seccomp profile no longer blocks bwrap's namespaces, but Docker's AppArmor profile refuses its first mount (`Failed to make / slave: Permission denied`).
  - With `apparmor=unconfined` as well, Docker's seccomp profile still refuses root's `pivot_root`.
  - `--privileged`: root's sandbox works. Other users stop at the network setup (`loopback: Failed RTM_NEWADDR`), because of the host's restriction on unprivileged user namespaces (Ubuntu 23.10 and later).
- **How it works:** at startup, unless `BUBBLEWRAP_WORKAROUND` is `0`, `app/wm.sh` installs the image's `/usr/share/ubuntu-desktop/bwrap` (from `conf/bwrap`) as `/usr/local/bin/bwrap`, in front of `/usr/bin/bwrap`. glycin runs `bwrap` through PATH, and `/usr/local/bin` comes first, in sudo's `secure_path` too. Only glycin's test changes: when it fails, the wrapper reports "Creating new namespace failed (…)", with bwrap's own message in the parentheses.
- **The trade-off:** where the sandbox can't start, images are decoded without it. A plain `docker run` already does that, and so did every image before glycin (`:24.04`).
- **Check:** `command -v bwrap` prints `/usr/local/bin/bwrap` (`/usr/bin/bwrap` with the workaround off). To see whether the sandbox itself starts here, first as root, then as yourself:
  ```
  sudo /usr/bin/bwrap --unshare-all --die-with-parent --dev /dev --ro-bind /usr /usr --tmpfs /tmp-home --symlink /usr/lib /lib --symlink /usr/lib64 /lib64 /usr/bin/true; echo "exit $?"
  /usr/bin/bwrap --unshare-all --die-with-parent --dev /dev --ro-bind /usr /usr --tmpfs /tmp-home --symlink /usr/lib /lib --symlink /usr/lib64 /lib64 /usr/bin/true; echo "exit $?"
  ```
  `exit 0`: the sandbox works. `No permissions to create a new namespace`: glycin falls back by itself. Any other `bwrap:` message: the workaround is what keeps GTK programs running.
- **Versions:** Ubuntu 26.04 has gdk-pixbuf 2.44.5, glycin 2.1.5 and bubblewrap 0.11.1. glycin has no setting to turn its sandbox off.

## Not needed
- **`--cap-add SYS_ADMIN` alone:** on hosts with AppArmor, FUSE still fails (`fuse: mount failed: Permission denied`).
- **`--security-opt seccomp=unconfined`:** none of the above needs it. On old Docker hosts it's the workaround in [troubleshooting/OLD_DOCKER.md](troubleshooting/OLD_DOCKER.md).
