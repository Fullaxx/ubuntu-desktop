#!/bin/bash

# Something is happening in the background ...
COUNT="0"
echo "Waiting for /var/opt/vivaldi to populate ..."
while [ ! -d /var/opt/vivaldi/media-codecs-* ] && [ ${COUNT} -lt 70 ]; do
  echo -n "."; sleep 0.1; COUNT=$(( COUNT + 1 ))
done

# WTF, really?
echo
echo "Waiting just a little longer ..."
echo -n "."
sleep 1
echo -n "."
sleep 1
echo -n "."
sleep 1
rm /opt/vivaldi/lib/libffmpeg.so
