#!/bin/bash
# This script runs as root
# Locale of the desktop session, from LOCALE (the image's ENV sets en_US): a UTF-8 locale from
# /usr/share/i18n/SUPPORTED, named with or without its codeset (de_DE, de_DE.UTF-8, hi_IN,
# sr_RS@latin, ...). The build generated en_US; any other locale is generated here at the
# container's first start (about a second) and kept for restarts.
# sudo's pam_env gives the session LANG from /etc/locale.conf (/etc/default/locale links to it) and
# LC_ALL from /etc/environment, so both are rewritten.
# It changes formats (dates, times, numbers, sorting), not the language of menus: the Ubuntu base
# image leaves out translations.
if [ -n "${LOCALE}" ]; then
  # the name without its codeset: de_DE.UTF-8 -> de_DE, sr_RS.UTF-8@latin -> sr_RS@latin
  LOCALEBASE="${LOCALE/.UTF-8/}"
  LOCALEBASE="${LOCALEBASE/.utf8/}"
  # SUPPORTED lists a UTF-8 locale with its codeset (de_DE.UTF-8) or, if it has no other, without (hi_IN)
  LOCALELINE=""
  case "${LOCALEBASE}" in
    *[!A-Za-z_@]*) ;;
    *) for LINE in "${LOCALEBASE}.UTF-8 UTF-8" "${LOCALEBASE} UTF-8"; do
         if grep -q -F -x "${LINE}" /usr/share/i18n/SUPPORTED; then LOCALELINE="${LINE}"; break; fi
       done ;;
  esac
  if [ -n "${LOCALELINE}" ]; then
    # locale-gen names it with .UTF-8 before any @modifier (hi_IN.UTF-8, sr_RS.UTF-8@latin)
    case "${LOCALEBASE}" in
      *@*) LANGNAME="${LOCALEBASE%%@*}.UTF-8@${LOCALEBASE#*@}" ;;
        *) LANGNAME="${LOCALEBASE}.UTF-8" ;;
    esac
    # an ungenerated locale reports the ASCII charmap
    if [ "$(LC_ALL=${LANGNAME} locale charmap 2>/dev/null)" != "UTF-8" ]; then
      grep -q -F -x "${LOCALELINE}" /etc/locale.gen || echo "${LOCALELINE}" >> /etc/locale.gen
      # --keep-existing leaves the locales the image already has alone
      locale-gen --keep-existing
    fi
    echo "LANG=${LANGNAME}" > /etc/locale.conf
    sed -i -e "s/^LC_ALL=.*/LC_ALL=${LANGNAME}/" /etc/environment
  else
    # a typo shouldn't stop the desktop: say so in docker logs and keep the image's locale
    echo "LOCALE='${LOCALE}' is not a UTF-8 locale in /usr/share/i18n/SUPPORTED; keeping $(cat /etc/locale.conf)" >&2
  fi
fi
