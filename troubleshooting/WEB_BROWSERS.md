# Web browser tabs crash

If web browser tabs crash, such as "Aw, Snap!" in Chrome, Chromium, Brave, Edge and Vivaldi, or "Gah. Your tab just crashed." in Firefox, give the container more shared memory:
```
--shm-size 2g
```
- **Why:** browsers share memory between their processes through `/dev/shm`, and Docker gives a container 64 MB of it.
- **Check:** in a terminal in the desktop, `df -h /dev/shm` shows its size: `64M` by default, `2.0G` with `--shm-size 2g`.
- Thanks to [jlesage](https://hub.docker.com/r/jlesage/firefox/#increasing-shared-memory-size).
