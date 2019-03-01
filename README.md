# Ubuntu 18.04 (Bionic) Desktop running Openbox in VNC

## Base Docker Image
Ubuntu 18.04 (x64)

## Get the image from Docker Hub

    docker pull fullaxx/ubuntu-desktop

## Run the image on localhost port 5901 with default configuration

    docker run -d -p 127.0.0.1:5901:5901 fullaxx/ubuntu-desktop

## Run the image on localhost port 5901 with Depth 16
    docker run -d -p 127.0.0.1:5901:5901 -e VNCDEPTH='16' fullaxx/ubuntu-desktop

## Run the image on localhost port 5901 with 1920x1080 Resolution
    docker run -d -p 127.0.0.1:5901:5901 -e VNCRES='1920x1080' fullaxx/ubuntu-desktop

## Run the image on localhost port 5901 with Password Authentication
    docker run -d -p 127.0.0.1:5901:5901 -e VNCPASS='vncpass' fullaxx/ubuntu-desktop

## Run the image on localhost port 5901 with Read-Write password and Read-Only password
Using the Read-Only password function requires a Read-Write password to be set
    docker run -d -p 127.0.0.1:5901:5901 -e VNCPASS='vncpass' -e VNCPASSRO='readonly' fullaxx/ubuntu-desktop

## Connect using vncviewer

    vncviewer 127.0.0.1:5901

## Build it locally using the github repository

    docker build -t="fullaxx/ubuntu-desktop" github.com/Fullaxx/ubuntu-desktop
