# Ubuntu 18.04 (Bionic) Desktop running Openbox in VNC

## Base Docker Image
Ubuntu 18.04 (x64)

## Get the image from Docker Hub

    docker pull fullaxx/ubuntu-desktop

## Run the image on port 5901

    docker run -d -p 5901:5901 fullaxx/ubuntu-desktop

## Connect using vncviewer

default password is vncpass

    vncviewer :1
    vncviewer 127.0.0.1:1
    vncviewer 127.0.0.1:5901

## Build it locally using the github repository

    docker build -t="fullaxx/ubuntu-desktop" github.com/Fullaxx/ubuntu-desktop
