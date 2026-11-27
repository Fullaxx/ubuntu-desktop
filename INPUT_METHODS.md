# Input methods

Chinese, Japanese, Korean, Vietnamese, the Indian scripts and many other languages are typed through an input method: you type letters, and it turns them into the characters you pick. The desktop gets one when the container starts with `docker run -e INPUT_METHOD`:
```
-e INPUT_METHOD='pinyin'
```
It's optional: without it, nothing is installed and typing works as before. With it, the container's first start installs [fcitx5](https://fcitx-im.org), the input methods it names and the fonts they type in, which takes about 15 seconds and 165 to 360 MB (see [First start](#first-start)). Like the other variables, it's read at every start, but a container keeps the value it was created with: to change it, start a new container. In docker compose it goes under `environment:`.

"The desktop" below means the Openbox session and every program started from it.

## Common setups
A Chinese desktop, typing with Pinyin
```
-e LOCALE='zh_CN' -e INPUT_METHOD='pinyin'
```
Traditional Chinese, typing with Zhuyin (Bopomofo)
```
-e LOCALE='zh_TW' -e INPUT_METHOD='chewing'
```
A Japanese desktop, typing with Mozc, which needs a desktop user other than root: here the built-in `ubuntu` account ([Mozc and root](#mozc-and-root))
```
-e LOCALE='ja_JP' -e INPUT_METHOD='mozc' -e VNCUSERMAP='ubuntu/1000'
```
A Japanese desktop as root (the default user), typing with Anthy
```
-e LOCALE='ja_JP' -e INPUT_METHOD='anthy'
```
A Korean desktop
```
-e LOCALE='ko_KR' -e INPUT_METHOD='hangul'
```
A Vietnamese desktop
```
-e LOCALE='vi_VN' -e INPUT_METHOD='unikey'
```
An English desktop that types Chinese, Japanese and Korean
```
-e INPUT_METHOD='pinyin,anthy,hangul'
```
`LOCALE` sets the language of menus and dialogs ([LOCALE.md](LOCALE.md)), and `INPUT_METHOD` adds typing, plus the font for its languages, which those menus and dialogs need too in this image ([Fonts](#fonts)). Any combination works.

## Names
`INPUT_METHOD` takes fcitx5's names for its input methods, separated by commas. Until you've used another, Ctrl+Space turns on the first one ([Typing](#typing)).

| Language | Name | Typing | Size, on top of fcitx5's 161 MB and the [font](#fonts) |
|---|---|---|---|
| Chinese (Simplified) | `pinyin` | Pinyin | 49 MB |
| | `shuangpin` | Shuangpin | in `pinyin`'s package |
| | `wbx`, `wbpy`, `erbi`, `qxm`, `wanfeng`, `zrm` | Wubi, Wubi with Pinyin, and other shape tables | in `pinyin`'s package |
| Chinese (Traditional) | `chewing` | Zhuyin (Bopomofo) | 7 MB |
| | `cangjie` | Cangjie | in `pinyin`'s package |
| | `cangjie5`, `quick5`, `boshiamy` and more | more tables, one package each (`fcitx5-table-<name>`) | small |
| Chinese, either | `rime` | Rime, with Luna Pinyin, Terra Pinyin, Bopomofo, Cangjie 5 and Stroke | 106 MB |
| Japanese | `mozc` | Romaji to kana and kanji; needs a desktop user other than root ([Mozc and root](#mozc-and-root)) | 27 MB |
| | `anthy` | Romaji to kana and kanji, as root too | 28 MB |
| Korean | `hangul` | Hangul (2-set keyboard) | 7 MB |
| Vietnamese | `unikey` | Telex, VNI | under 1 MB |
| | `bamboo` | Telex, VNI | 2 MB |
| The Indian scripts, Thai, Amharic and many more | `m17n_<language>_<name>` | m17n's input methods: `m17n_hi_inscript2` (Hindi, InScript), `m17n_ta_tamil99` (Tamil 99), `m17n_th_kesmanee` (Thai) and 200 others | 11 MB |

An m17n name comes from m17n's file for it, `/usr/share/m17n/<language>-<name>.mim`: `hi-inscript2.mim` is `m17n_hi_inscript2`.

## Mozc and root
Mozc doesn't work when the desktop runs as root, which it does unless `VNCUSERMAP` is set ([README](README.md#non-root-users)): its server, `mozc_server`, refuses to run as root. So on a root desktop, `mozc` is left out, and `docker logs` says so (see [Errors](#errors)). Either type Japanese with `anthy`, which works as root, or run the desktop as a user, such as the built-in `ubuntu` account:
```
-e INPUT_METHOD='mozc' -e VNCUSERMAP='ubuntu/1000'
```
Don't add Mozc by hand on a root desktop either: fcitx5 hangs waiting for Mozc's server, for minutes, and typing stops in the whole desktop.

## Typing
- **Ctrl+Space** turns the input method on and off. It turns on the one you used last: the first name in `INPUT_METHOD`, until you've used another.
- **Another input method:** keep Ctrl held and press Space again. Each press goes on to the next one in the list, which is plain letters followed by the names in `INPUT_METHOD`, and starts over after the last one. With `pinyin,anthy,hangul` and Pinyin on, holding Ctrl and pressing Space four times goes to plain letters, Pinyin, Anthy, then Hangul.
- **Left Shift** switches between plain letters and the input method you were using.
- **The fcitx5 icon**, in the panel's tray, shows which one is on.
- For example:
  - Pinyin: type `nihao`, then pick 你好 with Space (the first choice) or its number.
  - Mozc: type `konnichiha`, press Space to convert and Enter to accept: こんにちは.
  - Anthy: type `konnichiha` and press Enter to accept the kana as typed: こんにちは. Space converts to kanji first.
  - Hangul: the keys follow the Korean 2-set layout, so `dkssud` gives 안녕.

## Mac clients
macOS uses Ctrl+Space itself, to switch its own input sources, so a VNC viewer on a Mac may never see it. Either turn that shortcut off on the Mac (System Settings > Keyboard > Keyboard Shortcuts > Input Sources), or give fcitx5 another key: Fcitx 5 Configuration > Global Options > Toggle Input Method.

## Settings, and more input methods later
- **Fcitx 5 Configuration** (in the panel's menu under Settings, or from the fcitx5 icon's menu) adds, removes and orders the input methods, changes the keys, and holds each input method's own options. Its changes are kept in `~/.config/fcitx5`, which `docker restart` keeps.
- **Another input method later:** install its package from a terminal in the desktop (`apt-get` runs without a password for the desktop user), with its font if the container doesn't have it yet ([Fonts](#fonts)), restart fcitx5, then add it in Fcitx 5 Configuration:
  ```
  sudo apt-get update && sudo apt-get install -y fcitx5-hangul fonts-noto-cjk
  fcitx5 -r -d
  ```
  Like anything installed that way, it lasts as long as the container; a new container gets it from `INPUT_METHOD` instead.
- **If you quit fcitx5** (Exit, in its icon's menu), `fcitx5 -d` in a terminal starts it again, and so does `docker restart`.

## First start
- The first start installs fcitx5, its plugins for GTK and Qt 6 programs (with GTK 4 and Qt 6 themselves, which this image doesn't have), its settings program, the input methods' packages and their fonts from Ubuntu's archive, so it needs the network. The desktop comes up when that's done: the install takes about 15 seconds on a fast connection, and the desktop comes up about 25 seconds after `docker run` instead of 3.
- The container grows by fcitx5's 161 MB, plus each input method's size from [Names](#names) and its font from [Fonts](#fonts): 165 MB with `unikey`, 284 MB with `mozc,hangul`, 299 MB with `pinyin`, 356 MB with `rime`.
- `docker logs` shows
  ```
  Input method: installing fcitx5 fcitx5-frontend-gtk2 fcitx5-frontend-gtk3 fcitx5-frontend-gtk4 fcitx5-frontend-qt6 fcitx5-config-qt fcitx5-chinese-addons fonts-noto-cjk (first start only)
  Input method: installed in 14 s
  Input method: pinyin (fcitx5; Ctrl+Space switches)
  ```
- `docker restart` keeps it all, and prints only the last line. A new container installs it again.
- Qt 5 programs (VLC, for example) get no fcitx5 plugin, which would add 30 MB. `sudo apt-get install -y fcitx5-frontend-qt5` adds it, for Qt 5 programs started afterwards.

## Errors
A name that isn't an input method doesn't stop the container, and the other names still work. `docker logs` says
```
INPUT_METHOD: 'klingon' is not an input method (there is no package fcitx5-table-klingon); INPUT_METHODS.md lists them
```
`mozc` on a root desktop is left out the same way ([Mozc and root](#mozc-and-root)):
```
INPUT_METHOD: 'mozc' doesn't work when the desktop runs as root, so it's left out; use anthy, or a non-root desktop user (VNCUSERMAP); see INPUT_METHODS.md
```
If none of the names works, or the install fails (no network, for example), the desktop starts without an input method:
```
INPUT_METHOD='klingon': no input method is installed; the desktop starts without one
```

## Fonts
This image's own fonts cover only Latin, Greek and Cyrillic ([LOCALE.md](LOCALE.md#fonts)), so the first start also installs the font each input method types in, unless the container has it already:

| Input methods | Font package | Size |
|---|---|---|
| Chinese, Japanese and Korean, m17n's included | `fonts-noto-cjk` | 91 MB, once for all three |
| The Indian scripts, Thai, Arabic, Amharic and more: m17n's, and the `thai`, `arabic`, `amharic`, `malayalam-phonetic` and `tamil-remington` tables | `fonts-noto-core` | 43 MB |
| Vietnamese (`unikey`, `bamboo`, `viqr`), and the `ipa-x-sampa`, `latex` and `compose` tables | `fonts-dejavu-core` | 4 MB |

Menus and dialogs in those languages (`LOCALE`) then show too. Two of these fonts also become the desktop's own font, for every language: `fonts-noto-core` makes it Noto Sans, and `fonts-dejavu-core` without it makes it DejaVu Sans. `fonts-noto-cjk` leaves it as it is.

## How it works
- At every start, before the desktop, `app/input.sh` runs as root. With `INPUT_METHOD` set, it:
  - leaves out `mozc` if the desktop runs as root (UID 0), before installing anything: Mozc's server refuses to run as root, and fcitx5 would hang waiting for it;
  - installs what's missing: fcitx5, each name's package, and the font its input methods type in (only a first start finds anything missing);
  - checks each name against what's installed: `/usr/share/fcitx5/inputmethod/<name>.conf`, or m17n's `.mim` file;
  - writes the desktop user's `~/.config/fcitx5/profile` (plain letters first, then the names) and `~/.config/fcitx5/conf/xcb.conf`, each only if it isn't there yet, so changes made in Fcitx 5 Configuration last;
  - moves fcitx5's own `org.fcitx.Fcitx5.desktop` from the menu to `/etc/xdg/autostart`, so the desktop session starts fcitx5 (`openbox-session` runs those entries through `openbox-xdg-autostart`). Ubuntu's fcitx5 package doesn't start it by itself: its `im-config` does that from `/etc/X11/Xsession.d`, which a VNC session doesn't run. In the menu, "Fcitx 5" only started a second fcitx5, which quits at once because one is already running;
  - removes two menu entries from fcitx5's packages that can't do anything here: the Wayland launcher, which is for KDE Plasma on Wayland, and Fcitx 5 Migration Wizard, which imports Fcitx 4 settings. An upgrade of those packages brings them back until the next start.
- The session's start script (`xstartup`) starts Openbox with a D-Bus of its own (`dbus-launch --exit-with-session`), so fcitx5, the programs and Fcitx 5 Configuration share one bus, which ends with the session. Without it, fcitx5 finds no bus, and the first program that calls it starts a second fcitx5, on a bus of its own.
- When that autostart entry exists, `xstartup` also sets `GTK_IM_MODULE`, `QT_IM_MODULE`, `XMODIFIERS`, `SDL_IM_MODULE` and `GLFW_IM_MODULE`. Programs started in the desktop then use fcitx5: GTK and Qt programs through fcitx5's plugins and the session's D-Bus, xterm and Java programs through XIM.
- `xcb.conf` turns off fcitx5's "Allow Overriding System XKB Settings". The VNC server translates the client's keys itself, and fcitx5 would otherwise load its own keyboard layout into it.

## Checking a container
What the start script reported:
```
docker logs <container> | grep -E '^(Input method|INPUT_METHOD)'
```
In a terminal in the desktop:
- `fcitx5-remote` prints 1 while plain letters are on and 2 while the input method is on (0: fcitx5 isn't running, or no window has focus).
- `fcitx5-diagnose` reports the whole setup. Three of its complaints don't apply here: it can't find the fcitx5 modules for GTK 2 and 3 (it looks for `gtk-query-immodules`, which the image doesn't have, but the modules are installed), there are no Qt 4 or Qt 5 modules (see [First start](#first-start)), and it can't determine the desktop environment (Openbox doesn't name one).
