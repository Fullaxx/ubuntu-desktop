#!/bin/bash

if [ -z "$1" ]; then
  >&2 echo "$0: <VERSION>"
  exit 1
fi

# Input Validation
unset NODEVERS
case "$1" in
  22) NODEVERS="$1";;
  21) NODEVERS="$1";;
  20) NODEVERS="$1";;
  19) NODEVERS="$1";;
  18) NODEVERS="$1";;
  17) NODEVERS="$1";;
  16) NODEVERS="$1";;
  15) NODEVERS="$1";;
  14) NODEVERS="$1";;
  13) NODEVERS="$1";;
  12) NODEVERS="$1";;
  11) NODEVERS="$1";;
  10) NODEVERS="$1";;
   9) NODEVERS="$1";;
   8) NODEVERS="$1";;
   7) NODEVERS="$1";;
   6) NODEVERS="$1";;
   5) NODEVERS="$1";;
   4) NODEVERS="$1";;
   *) >&2 echo "$1: not valid"; exit 2;;
esac

curl -fsSL https://deb.nodesource.com/setup_${NODEVERS}.x | bash -
