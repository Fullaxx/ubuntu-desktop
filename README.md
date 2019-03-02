# Ubuntu 18.04 (Bionic) Desktop running Openbox in VNC

## Base Docker Image
Ubuntu 18.04 (x64)

## Get the image from Docker Hub

    docker pull fullaxx/ubuntu-desktop

## Run the image
Run the image on localhost port 5901 with default configuration

    docker run -d -p 127.0.0.1:5901:5901 fullaxx/ubuntu-desktop

Run the image with Depth 16

    docker run -d -p 127.0.0.1:5901:5901 -e VNCDEPTH='16' fullaxx/ubuntu-desktop

Run the image with 1920x1080 Resolution

    docker run -d -p 127.0.0.1:5901:5901 -e VNCRES='1920x1080' fullaxx/ubuntu-desktop

Run the image with Password Authentication

    docker run -d -p 127.0.0.1:5901:5901 -e VNCPASS='vncpass' fullaxx/ubuntu-desktop

Run the image with Read-Write and Read-Only password (Using R/O pass requires R/W pass)

    docker run -d -p 127.0.0.1:5901:5901 -e VNCPASS='vncpass' -e VNCPASSRO='readonly' fullaxx/ubuntu-desktop

## Connect using vncviewer

    vncviewer 127.0.0.1:5901

## Using Openbox
Right-Click to activate the Openbox menu system. You will find a number of convenience scripts for running applications.

Terminals:
* xterm, uxterm, tilix, terminator

Browsers:
* chrome, chromium, firefox, vivaldi

Editors:
* gedit, libreoffice, bluefish, geany, vscode

Torrenting:
* qbittorrent, ktorrent, deluge, transmission-gtk, bitstormlite

## Build it locally using the github repository

    docker build -t="fullaxx/ubuntu-desktop" github.com/Fullaxx/ubuntu-desktop
