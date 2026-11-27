#!/bin/bash
# This script runs as root
# Input method for typing Chinese, Japanese, Korean, Vietnamese and more, from docker run's
# -e INPUT_METHOD: fcitx5 input method names, comma-separated (pinyin, mozc, hangul, ...; INPUT_METHODS.md).
# Without it nothing is installed or started. The container's first start installs fcitx5, the
# engines that provide those names and the fonts they type in, if the image lacks them (a restart
# finds them installed), then writes the desktop user's fcitx5 profile before fcitx5 first runs
# (fcitx5 drops entries it can't find and rewrites the file on exit). /etc/xdg/autostart starts
# fcitx5 in the session; xstartup sets the variables programs read
IMAUTOSTART="/etc/xdg/autostart/org.fcitx.Fcitx5.desktop"
if [ -n "${INPUT_METHOD}" ]; then
  # fcitx5, its plugins for GTK 2/3/4 and Qt 6 programs (xterm and Java use XIM, which is built in),
  # and its settings program
  IMPKGS="fcitx5 fcitx5-frontend-gtk2 fcitx5-frontend-gtk3 fcitx5-frontend-gtk4 fcitx5-frontend-qt6 fcitx5-config-qt"
  # Each name with the package that provides it (name:package), and each package once in IMPKGS
  IMPAIRS=""
  for IM in ${INPUT_METHOD//,/ }; do
    IMEXTRA=""
    case "${IM}" in
      *[!A-Za-z0-9_-]*) echo "INPUT_METHOD: '${IM}' is not an input method name; INPUT_METHODS.md lists them" >&2; continue ;;
      pinyin|shuangpin|wbx|wbpy|cangjie|erbi|qxm|wanfeng|zrm) IMPKG="fcitx5-chinese-addons" ;;
      # Mozc's server (mozc_server) refuses to run as root (UID 0), and fcitx5 then hangs waiting for it,
      # for minutes, so typing stops in the whole desktop: a root desktop (no VNCUSERMAP,
      # app/useracct.sh) goes without mozc. anthy, the other Japanese input method, works as root
      mozc)
        if [ "$(id -u "${USER:-root}")" = "0" ]; then
          echo "INPUT_METHOD: 'mozc' doesn't work when the desktop runs as root, so it's left out; use anthy, or a non-root desktop user (VNCUSERMAP); see INPUT_METHODS.md" >&2
          continue
        fi
        IMPKG="fcitx5-mozc" ;;
      anthy|hangul|unikey|bamboo|chewing) IMPKG="fcitx5-${IM}" ;;
      # rime types nothing without schemas: the ones its default configuration lists (only recommended
      # by Ubuntu's packages, so --no-install-recommends would leave them out)
      rime) IMPKG="fcitx5-rime"; IMEXTRA="rime-data-luna-pinyin rime-data-terra-pinyin rime-data-bopomofo rime-data-cangjie5 rime-data-stroke" ;;
      m17n_*) IMPKG="fcitx5-m17n" ;;
      # the other Chinese tables come one per package: cangjie5, quick5, boshiamy, ...
      *) IMPKG="fcitx5-table-${IM}" ;;
    esac
    IMPAIRS="${IMPAIRS:+${IMPAIRS} }${IM}:${IMPKG}"
    for IMP in ${IMPKG} ${IMEXTRA}; do
      case " ${IMPKGS} " in *" ${IMP} "*) ;; *) IMPKGS="${IMPKGS} ${IMP}" ;; esac
    done
  done

  # First start: install what's missing (a restart finds it installed). If every name was turned
  # down above, nothing is, and the package lists aren't fetched for nothing
  IMMISSING=""
  for IMPKG in ${IMPAIRS:+${IMPKGS}}; do
    if ! dpkg -s "${IMPKG}" 2>/dev/null | grep -q -x 'Status: install ok installed'; then
      IMMISSING="${IMMISSING:+${IMMISSING} }${IMPKG}"
    fi
  done
  if [ -n "${IMMISSING}" ]; then
    # The image ships no package lists: fetch them unless an earlier start (or a launcher script) did,
    # so a misspelled name doesn't fetch them again at every restart
    if ! compgen -G "/var/lib/apt/lists/*_Packages*" >/dev/null; then
      apt-get -qq update || echo "INPUT_METHOD: apt-get update failed, so nothing is installed" >&2
    fi
    # Install only if a name's package exists (fcitx5 alone would be of no use), and leave out what
    # apt doesn't have (a misspelled name, reported below), so the rest still installs
    IMUSABLE=""
    for IMPAIR in ${IMPAIRS}; do
      if apt-cache show "${IMPAIR#*:}" >/dev/null 2>&1; then IMUSABLE="yes"; break; fi
    done
    IMINSTALL=""
    for IMPKG in ${IMUSABLE:+${IMMISSING}}; do
      if apt-cache show "${IMPKG}" >/dev/null 2>&1; then
        IMINSTALL="${IMINSTALL:+${IMINSTALL} }${IMPKG}"
        # The fonts its input methods type in, if the image lacks them (ubuntu-desktop has only Latin,
        # Greek and Cyrillic; the Xfce image has all three). Only a package that exists brings one,
        # so a misspelled name brings none
        case "${IMPKG}" in
          # m17n's input methods cover many scripts, and a few type Chinese, Japanese or Korean
          # (and Vietnamese in Han characters, Chữ Nôm)
          fcitx5-m17n)
            IMFONT="fonts-noto-core"
            case " ${IMPAIRS}" in *" m17n_zh_"*|*" m17n_ja_"*|*" m17n_ko_"*|*" m17n_vi_han:"*|*" m17n_vi_nom"*) IMFONT="${IMFONT} fonts-noto-cjk" ;; esac ;;
          # fcitx5's tables are Chinese (the CJK line below; "emoji" too, Chinese kaomoji), except
          # these: other scripts,
          fcitx5-table-amharic|fcitx5-table-arabic|fcitx5-table-malayalam-phonetic|fcitx5-table-tamil-remington|fcitx5-table-thai) IMFONT="fonts-noto-core" ;;
          # Vietnamese, and the Latin letters, IPA and symbols that ubuntu-desktop's own fonts lack,
          fcitx5-unikey|fcitx5-bamboo|fcitx5-table-viqr|fcitx5-table-compose|fcitx5-table-ipa-x-sampa|fcitx5-table-latex) IMFONT="fonts-dejavu-core" ;;
          # and Cyrillic, which every image's own fonts cover
          fcitx5-table-rustrad|fcitx5-table-translit|fcitx5-table-translit-ua|fcitx5-table-yawerty) IMFONT="" ;;
          fcitx5-chinese-addons|fcitx5-chewing|fcitx5-rime|fcitx5-table-*|fcitx5-mozc|fcitx5-anthy|fcitx5-hangul) IMFONT="fonts-noto-cjk" ;;
          *) IMFONT="" ;;
        esac
        for IMF in ${IMFONT}; do
          if ! dpkg -s "${IMF}" 2>/dev/null | grep -q -x 'Status: install ok installed'; then
            case " ${IMINSTALL} " in *" ${IMF} "*) ;; *) IMINSTALL="${IMINSTALL} ${IMF}" ;; esac
          fi
        done
      fi
    done
    if [ -n "${IMINSTALL}" ]; then
      echo "Input method: installing ${IMINSTALL} (first start only)"
      IMSTART=$(date +%s)
      # Lists left by an earlier start can be out of date: fetch them once more if the install fails
      # shellcheck disable=SC2086
      if apt-get -qq install -y --no-install-recommends ${IMINSTALL} >/dev/null || \
         { apt-get -qq update && apt-get -qq install -y --no-install-recommends ${IMINSTALL} >/dev/null; }; then
        echo "Input method: installed in $(( $(date +%s) - IMSTART )) s"
      else
        echo "INPUT_METHOD: apt-get install failed" >&2
      fi
    fi
  fi

  # Keep the names that are installed now: an input method has /usr/share/fcitx5/inputmethod/<name>.conf,
  # except m17n's, which come from m17n-db (m17n_<lang>_<name> is /usr/share/m17n/<lang>-<name>.mim)
  IMNAMES=""
  for IMPAIR in ${IMPAIRS}; do
    IM="${IMPAIR%%:*}"; IMPKG="${IMPAIR#*:}"
    case " ${IMNAMES} " in *" ${IM} "*) continue ;; esac
    case "${IM}" in
      m17n_*) IMM17N="${IM#m17n_}"; IMFILE="/usr/share/m17n/${IMM17N%%_*}-${IMM17N#*_}.mim" ;;
      *) IMFILE="/usr/share/fcitx5/inputmethod/${IM}.conf" ;;
    esac
    if [ -f "${IMFILE}" ]; then
      IMNAMES="${IMNAMES:+${IMNAMES} }${IM}"
    elif dpkg -s "${IMPKG}" 2>/dev/null | grep -q -x 'Status: install ok installed'; then
      echo "INPUT_METHOD: '${IM}' is not one of ${IMPKG}'s input methods; INPUT_METHODS.md lists them" >&2
    elif ! apt-cache show "${IMPKG}" >/dev/null 2>&1 && compgen -G "/var/lib/apt/lists/*_Packages*" >/dev/null; then
      echo "INPUT_METHOD: '${IM}' is not an input method (there is no package ${IMPKG}); INPUT_METHODS.md lists them" >&2
    fi
  done

  if [ -n "${IMNAMES}" ] && [ -x /usr/bin/fcitx5 ]; then
    mkdir -p "${HOME}/.config/fcitx5/conf"
    # The desktop user's input methods: the keyboard first (Ctrl+Space switches to the others), then
    # the names. Written only if missing, so changes made in Fcitx 5 Configuration survive restarts;
    # app/prepare.sh gives HOME to a non-root desktop user afterwards
    if [ ! -f "${HOME}/.config/fcitx5/profile" ]; then
      {
        printf '[Groups/0]\nName=Default\nDefault Layout=us\nDefaultIM=%s\n\n' "${IMNAMES%% *}"
        IMN=0
        for IM in keyboard-us ${IMNAMES}; do
          printf '[Groups/0/Items/%d]\nName=%s\nLayout=\n\n' "${IMN}" "${IM}"
          IMN=$(( IMN + 1 ))
        done
        printf '[GroupOrder]\n0=Default\n'
      } > "${HOME}/.config/fcitx5/profile"
    else
      for IM in ${IMNAMES}; do
        if ! grep -q -x "Name=${IM}" "${HOME}/.config/fcitx5/profile"; then
          echo "INPUT_METHOD: '${IM}' is not in the existing ${HOME}/.config/fcitx5/profile; add it in Fcitx 5 Configuration" >&2
        fi
      done
    fi
    # Leave the keyboard map alone: the VNC server maps the client's keys itself, and fcitx5 would
    # otherwise load its own layout into the X server
    if [ ! -f "${HOME}/.config/fcitx5/conf/xcb.conf" ]; then
      echo "Allow Overriding System XKB Settings=False" > "${HOME}/.config/fcitx5/conf/xcb.conf"
    fi
    # Start fcitx5 with the session: Ubuntu's package has no autostart entry of its own (im-config
    # starts it from Xsession, which a VNC session doesn't run). Its menu entry, "Fcitx 5", moves
    # there: in the menu it only started a second fcitx5, which quits at once because one is already
    # running (a restart finds the file moved; an upgrade that brings it back gets it moved again)
    if [ -f /usr/share/applications/org.fcitx.Fcitx5.desktop ]; then
      # (ubuntu-desktop's image has no /etc/xdg/autostart until something puts an entry there)
      mkdir -p "${IMAUTOSTART%/*}"
      mv -f /usr/share/applications/org.fcitx.Fcitx5.desktop "${IMAUTOSTART}"
    fi
    # Menu entries from fcitx5's packages that can't do anything here: the Wayland launcher is for
    # KDE Plasma on Wayland, and the Migration Wizard imports Fcitx 4 settings. Removed rather than
    # hidden, because ubuntu-desktop's fbpanel menu lists every copy of an entry
    rm -f /usr/share/applications/fcitx5-wayland-launcher.desktop \
          /usr/share/applications/org.fcitx.fcitx5-migrator.desktop
    echo "Input method: ${IMNAMES} (fcitx5; Ctrl+Space switches)"
  else
    rm -f "${IMAUTOSTART}"
    echo "INPUT_METHOD='${INPUT_METHOD}': no input method is installed; the desktop starts without one" >&2
  fi
fi
