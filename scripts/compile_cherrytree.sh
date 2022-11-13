#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y git build-essential cmake ninja-build libgtkmm-3.0-dev libgtksourceviewmm-3.0-dev libxml++2.6-dev libsqlite3-dev gettext libgspell-1-dev libcurl4-openssl-dev libuchardet-dev libfmt-dev libspdlog-dev gnome-icon-theme libfribidi-dev libvte-2.91-dev texlive-latex-base dvipng

cd /opt
if [ ! -d cherrytree ]; then
  git clone https://github.com/giuspen/cherrytree.git
fi
cd cherrytree
git submodule update --init
./build.sh
./build/cherrytree

# Install documentation:
# apt-get install -y devhelp libgtkmm-3.0-doc libgtksourceviewmm-3.0-doc libglibmm-2.4-doc libpangomm-1.4-doc libxml++2.6-doc libgspell-1-doc
