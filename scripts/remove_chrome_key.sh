#!/bin/bash

# for some reason this file causes problems with apt

cd /etc/apt/sources.list.d
while [ true ]; do
  if [ -f google-chrome.list ]; then
    rm google-chrome.list
    exit 0
  else
    sleep 0.1
  fi
done
