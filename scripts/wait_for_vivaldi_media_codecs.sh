#!/bin/bash

# vivaldi-stable's postinst downloads the proprietary media codecs in the background (/opt/vivaldi/update-ffmpeg).
# Wait for them, so Vivaldi's first start already uses them: its launcher (/opt/vivaldi/vivaldi) preloads
# /var/opt/vivaldi/media-codecs-*/libffmpeg.so ahead of the bundled /opt/vivaldi/libffmpeg.so, so nothing is removed.
# update-ffmpeg moves libffmpeg.so into place only after checking its sha256, so once it's there, it's complete.
# If it isn't there after 60 s, Vivaldi's launcher downloads the codecs for the user when it starts.
COUNT="0"
echo "Waiting for Vivaldi's media codecs to download ..."
while ! ls /var/opt/vivaldi/media-codecs-*/libffmpeg.so >/dev/null 2>&1 && [ ${COUNT} -lt 60 ]; do
  echo -n "."; sleep 1; COUNT=$(( COUNT + 1 ))
done
echo
