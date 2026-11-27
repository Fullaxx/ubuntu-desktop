# Time zone, locale and language

Three things about the desktop can be set when the container starts, with `docker run -e`:
- the **time zone** (`TZ`): the clock
- the **locale** (`LOCALE`, or `LANG`): how dates, times and numbers are written, and the language of the programs that have a translation
- the **language** on its own (`LANGUAGE`): the language of those programs, without changing the formats

All of them are optional. They're read every time the container starts, but a container keeps the values it was created with: to change one, start a new container (`docker restart` won't pick up a change). In docker compose they go under `environment:`.

Typing languages that need an input method, such as Chinese, Japanese and Korean, is set up on its own, with `INPUT_METHOD`: [INPUT_METHODS.md](INPUT_METHODS.md).

"The desktop" below means the openbox session and every program started from it, including its terminals.

## Defaults
Without any of these variables:

| | The desktop | A `docker exec` shell |
|---|---|---|
| Time zone | UTC | UTC |
| Locale | `en_US.UTF-8`: `11/19/2026`, `03:12:31 PM`, `1,234,567.89`, weeks start on Sunday | none (POSIX): ASCII only |
| Language | English | English |

## Quick reference

| Variable | Without it | Sets | Reaches | Example |
|---|---|---|---|---|
| `TZ` | UTC | the time zone | the desktop, `docker exec` shells, `/etc/localtime` | `-e TZ='Europe/Berlin'` |
| `LOCALE` | `en_US` | the language and the formats | the desktop | `-e LOCALE='de_DE'` |
| `LANG` | `en_US` in the desktop, none in `docker exec` | the same as `LOCALE`, when `LOCALE` isn't set | the desktop, `docker exec` shells | `-e LANG='de_DE.UTF-8'` |
| `LANGUAGE` | the locale's language | the language only | the desktop; `docker exec` shells only with `LANG` | `-e LANGUAGE='en'` |

## Common setups
Berlin, with German dates and numbers, and German in the programs that have a translation
```
-e TZ='Europe/Berlin' -e LOCALE='de_DE'
```
English text, with German dates and numbers
```
-e LOCALE='de_DE' -e LANGUAGE='en'
```
German text, with US dates and numbers
```
-e LANGUAGE='de'
```
English, with a 24-hour clock and the day first (`19/11/26`, `15:12:31`): `en_GB`, `en_IE` or `en_AU`
```
-e LOCALE='en_GB'
```
English, with ISO dates (`2026-11-19`) and weeks starting on Monday; numbers are written `1.234.567,89`
```
-e LOCALE='en_DK'
```
The same locale in `docker exec` shells too: use `LANG` instead of `LOCALE`
```
-e LANG='fr_FR.UTF-8'
```
Chinese, typing with Pinyin; the input method brings the font that Chinese needs ([INPUT_METHODS.md](INPUT_METHODS.md))
```
-e LOCALE='zh_CN' -e INPUT_METHOD='pinyin'
```

## Time zone (TZ)
- **Values:** a zone name from `/usr/share/zoneinfo`, usually Region/City: `Europe/Berlin`, `America/New_York`, `Asia/Kolkata`, `Australia/Sydney`, `UTC`.
  - Old names such as `US/Eastern`, `Asia/Calcutta` and `Europe/Kiev` aren't installed: Ubuntu moved them to the `tzdata-legacy` package. Use `America/New_York`, `Asia/Kolkata` and `Europe/Kyiv`.
  - For a fixed offset, the `Etc` zones have their sign inverted: `Etc/GMT-3` is UTC+3.
- **Default:** UTC.
- **Where:** the desktop, `docker exec` shells, and `/etc/localtime`, which points at the zone for programs that read the file instead of `TZ`. Daylight saving time follows the zone's rules.
- **A name that isn't a zone** (a typo, or an old name) doesn't stop the container. `docker logs` says
  ```
  TZ='Europe/Berlinn' is not a timezone in /usr/share/zoneinfo; /etc/localtime stays UTC
  ```
  and the clocks show UTC, labeled with the first part of the name (`Europe`) or with nothing.
- **POSIX rule strings** such as `CET-1CEST,M3.5.0,M10.5.0/3` work in the desktop and in `docker exec` shells, daylight saving time included, but `/etc/localtime` stays UTC and `docker logs` reports them the same way.

## Locale (LOCALE or LANG)
### What it changes
- Dates and times, numbers, sorting, and the first day of the week (in calendars).
- The language of every program that has a translation (see [What gets translated](#what-gets-translated)), unless `LANGUAGE` is set.

| Locale | Date and time | Short date | Number | Week starts |
|---|---|---|---|---|
| `en_US` (default) | `Thu 19 Nov 2026 03:12:31 PM UTC` | `11/19/2026` | `1,234,567.89` | Sunday |
| `en_GB` | `Thu 19 Nov 2026 15:12:31 UTC` | `19/11/26` | `1,234,567.89` | Monday |
| `en_CA` | `Thu 19 Nov 2026 03:12:31 PM` | `2026-11-19` | `1,234,567.89` | Sunday |
| `en_IN` | `Thursday 19 November 2026 03:12:31 PM` | `19/11/26` | `12,34,567.89` | Sunday |
| `en_DK` | `2026-11-19T15:12:31 UTC` | `2026-11-19` | `1.234.567,89` | Monday |
| `de_DE` | `Do 19 Nov 2026 15:12:31 UTC` | `19.11.2026` | `1.234.567,89` | Monday |
| `fr_FR` | `jeu. 19 nov. 2026 15:12:31` | `19/11/2026` | `1 234 567,89` | Monday |
| `es_MX` | `jue 19 nov 2026 15:12:31` | `19/11/26` | `1 234 567.89` | Sunday |
| `pt_BR` | `qui 19 nov 2026 15:12:31` | `19/11/2026` | `1.234.567,89` | Sunday |
| `ja_JP` | `2026年11月19日 15時12分31秒` | `2026年11月19日` | `1,234,567.89` | Sunday |

Chinese, Japanese, Korean, Hindi, Thai, Hebrew, Arabic, Vietnamese and some other languages need a font first: see [Fonts](#fonts). An input method for the language brings it too ([INPUT_METHODS.md](INPUT_METHODS.md#fonts)).

### Values
- **A UTF-8 locale from `/usr/share/i18n/SUPPORTED`**, with or without its codeset: `de_DE`, `de_DE.UTF-8`, `de_DE.utf-8` and `de_DE.utf8` are the same for the desktop (the codeset in any letter case, with or without its dash); `LANG` needs its codeset for `docker exec` shells (see below).
- **Modifiers** come last: `sr_RS@latin`, `ca_ES@valencia`.
- **`C` or `C.UTF-8`:** English, with POSIX formats (`Thu Nov 19 15:12:31 2026`).
- **Not accepted:** locales that aren't UTF-8, such as `de_DE.ISO-8859-1` or `de_DE@euro`.
- **Default:** `en_US`, generated when the image was built.

### LOCALE or LANG
- They take the same names. `LOCALE` wins when both are set; an empty `LOCALE` counts as not set.
- `LANG` also reaches `docker exec` shells, and its locale is generated for them, so commands run there use it too. Those shells use the value as it is, so write it with its codeset (`de_DE.UTF-8`, `de_DE.utf-8` or `de_DE.utf8`). With `LANG='de_DE'` the desktop is German, but `docker exec` shells stay POSIX, and perl warns.
- `LOCALE` doesn't reach `docker exec` shells: they stay POSIX.
- If `LOCALE` and `LANG` name different locales, the desktop follows `LOCALE`. `docker exec` shells get `LANG`, whose locale isn't generated, so perl prints `perl: warning: Setting locale failed` (in `apt-get`, for example).

### First start
- A locale other than `en_US` and `C` is generated at the container's first start. That takes about a second, and `docker logs` shows `Generating locales`.
- `docker restart` keeps it. A new container generates it again.

### Errors
A name that isn't a UTF-8 locale doesn't stop the container. `docker logs` says
```
LOCALE='de' is not a UTF-8 locale in /usr/share/i18n/SUPPORTED; keeping LANG=en_US.UTF-8
```
(it names `LANG` when the name came from `LANG`), and the desktop keeps `en_US`.

## Language (LANGUAGE)
- **Sets** the language of the programs that have a translation, on its own: dates and numbers keep following the locale.
- **Values:** a language code (`en`, `de`, `pt_BR`), or several separated by colons, tried in order (`pt_BR:pt`, `fr:en`). Programs use the first one they have a translation for, and skip the ones they don't (`xx` gives English).
- **Default:** not set, so the language follows the locale.
- **It needs a real locale:** with `C` or `C.UTF-8` it's ignored.
- **`docker exec` shells** see it, but they have no locale unless `LANG` is set too, so without `LANG` they stay English.
- Nothing checks the value: a misspelled code gives English, with no message in `docker logs`.

## What gets translated
- **openbox:** its window menu (Iconify, Maximize, Close, ...), its desktops menu and its messages, in 38 languages.
- **obconf**, the Openbox Configuration Manager, in 30 languages.
- **fbpanel:** its menu's categories and its settings, in French, Italian and Russian.
- The image keeps every package's translations (Ubuntu's base image leaves them out); for these three programs that's 75 files, under 1 MB.
- **Apps installed later** with `apt-get` or `dpkg`, including the ones the right-click menu's entries install, keep their translations too.
- **What stays English:**
  - The right-click menu: its entries are fixed English labels in openbox's `menu.xml`.
  - Program names in fbpanel's menu, unless the program's `.desktop` file has a translation (of the image's own, only obconf's has a few).
  - GTK's own labels, such as the file chooser and the Cut/Copy/Paste menu of text fields, and system error messages. Ubuntu ships those translations in separate language packs, which the image doesn't include.
  - xterm, and command-line tools from the base image, such as `apt` and `dpkg`.

## Fonts
The image's fonts (the URW fonts, such as Nimbus Sans, the desktop's font) cover Latin, Greek and Cyrillic.

Other scripts show as boxes until a font is added: Chinese, Japanese, Korean, the Indian scripts, Thai, Hebrew, Arabic, Persian, Vietnamese, Armenian, Georgian, Khmer, Burmese, Sinhala and Amharic, for example. This image leaves those fonts out to stay small. `INPUT_METHOD` installs the fonts for the languages it types, at the container's first start ([INPUT_METHODS.md](INPUT_METHODS.md#fonts)). [ubuntu-desktop-xfce](https://github.com/Fullaxx/ubuntu-desktop-xfce) has them built in, with these three packages (see its [Dockerfile](https://github.com/Fullaxx/ubuntu-desktop-xfce/blob/master/Dockerfile) and its [LOCALE.md](https://github.com/Fullaxx/ubuntu-desktop-xfce/blob/master/LOCALE.md#fonts)):

| Package | Covers | Size |
|---|---|---|
| `fonts-noto-cjk` | Chinese, Japanese, Korean | 91 MB |
| `fonts-noto-core` | Noto Sans and Serif, plus Hebrew, Arabic, Armenian, Georgian, the Indian scripts, Thai, Khmer, Lao, Burmese, Sinhala, Ethiopic and many more | 43 MB |
| `fonts-dejavu-core` | DejaVu: Latin, Greek, Cyrillic, Vietnamese, Hebrew, Arabic and more, and DejaVu Sans Mono | 4 MB |

With them, the image grows by about 142 MB, the desktop's font becomes Noto Sans, and the monospace font becomes DejaVu Sans Mono.

To add them to a running container, from a terminal in the desktop (`apt-get` runs without a password for the desktop user):
```
sudo apt-get update && sudo apt-get install -y fonts-dejavu-core fonts-noto-cjk fonts-noto-core
openbox --restart; pkill -x fbpanel; setsid -f fbpanel >/dev/null 2>&1
```
Programs started afterwards use the new fonts; the second line restarts openbox and the panel so their menus use them too. The fonts last as long as the container.

To keep them, build your own image on top of this one:
```
FROM ghcr.io/fullaxx/ubuntu-desktop
RUN apt-get update && apt-get install -y fonts-dejavu-core fonts-noto-cjk fonts-noto-core && rm -rf /var/lib/apt/lists/*
```
Or rebuild this image with them, as ubuntu-desktop-xfce does. Clone the repository:
```
git clone https://github.com/Fullaxx/ubuntu-desktop.git
cd ubuntu-desktop
```
In the Dockerfile, add the three packages to the `apt-get install` list, which is in alphabetical order:
```
      dbus-x11 \
      fonts-dejavu-core \
      fonts-noto-cjk \
      fonts-noto-core \
      gnome-icon-theme \
```
Name all three: with `fonts-noto-core` in the same install, apt leaves DejaVu out unless `fonts-dejavu-core` is listed. Then build it:
```
docker build -t ubuntu-desktop:fonts .
```

Typing Chinese, Japanese, Korean and more needs an input method: [INPUT_METHODS.md](INPUT_METHODS.md).

## Don't
- **`LC_ALL`:** the desktop uses it, but nothing generates its locale, so the desktop falls back to ASCII and English, with no message in `docker logs`. Use `LOCALE` or `LANG`.
- **`LC_TIME`, `LC_NUMERIC` and the other `LC_` variables:** they have no effect on the desktop, because the image sets `LC_ALL`, which overrides them. In `docker exec` shells, perl warns about them unless their locale was generated.
- **Locales that aren't UTF-8.**
- **`LANG` without its codeset** (`de_DE`): `docker exec` shells can't use it. Write `de_DE.UTF-8`.
- **`docker restart` after changing a variable:** the container keeps the values it was created with. Start a new one.

## How it works
- At every start, before the desktop, two scripts run as root:
  - `app/timezone.sh` points `/etc/localtime` at the zone named by `TZ`.
  - `app/locale.sh` takes `LOCALE`, or else `LANG`. It generates the locale if it's new (adding it to `/etc/locale.gen`), and writes it to `/etc/locale.conf` as `LANG` (`/etc/default/locale` links to that file) and to `/etc/environment` as `LC_ALL`.
- The desktop starts through sudo, and sudo's PAM reads those two files. sudo also passes `TZ`, `LANG`, `LANGUAGE` and the `LC_` variables through from `docker run`, when their values have no `%` or `/` (`TZ` gets its own check). A value passed through wins over the files: that's why `-e LC_ALL` overrides the image's.
- `docker exec` shells don't go through PAM: they get only `docker run`'s variables.
- The Dockerfile generates `en_US.UTF-8` (it isn't a build argument), and keeps the translations that the Ubuntu base image leaves out.

## Checking a container
The values the start scripts didn't accept:
```
docker logs <container> | grep -E "^(TZ|LOCALE|LANG)='"
```
In a terminal in the desktop, `locale` shows the locale and language variables, and `date` the time zone.
