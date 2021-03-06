#!/bin/bash

ASSETS_PATH=/app/assets
PLAYLIST_FILE_NAME=radio.m3u
MPD_CONFIG_FILE=/etc/mpd-radio-streamer.conf
PLAYLIST_BUILD_FULL_PATH="$ASSETS_PATH/$PLAYLIST_FILE_NAME"
PLAYLIST_PATH=/playlists

echo "PLAYLIST_BUILD_FULL_PATH = [$PLAYLIST_BUILD_FULL_PATH]"

cat /app/assets/mpd-template.conf > $MPD_CONFIG_FILE

httpd_always_on=$MPD_RADIO_STREAMER_HTTPD_ALWAYS_ON
if [ -z "${httpd_always_on}" ]; then
  httpd_always_on="yes"
else
  check=${httpd_always_on^^}
  if [[ "$check" == "Y" || "$check" == "YES" ]]; then
    httpd_always_on="yes"
  else
    httpd_always_on="no"
  fi
fi
echo "MPD_RADIO_STREAMER_HTTPD_ALWAYS_ON = [$httpd_always_on]"

httpd_tags=$MPD_RADIO_STREAMER_HTTPD_TAGS
if [ -z "${httpd_tags}" ]; then
  httpd_tags="yes"
else
  check=${httpd_tags^^}
  if [[ "$check" == "Y" || "$check" == "YES" ]]; then
    httpd_tags="yes"
  else
    httpd_tags="no"
  fi
fi
echo "MPD_RADIO_STREAMER_HTTPD_TAGS = [$httpd_tags]"

radio_name=$MPD_RADIO_STREAMER_NAME
if [ -z "${radio_name}" ]; then
  radio_name="Radio"
fi
echo "MPD_RADIO_STREAMER_NAME = [$radio_name]"

httpd_format=$MPD_RADIO_STREAMER_HTTPD_FORMAT

sed -i 's/MPD_RADIO_STREAMER_HTTPD_NAME/'"$httpd_name"'/g' $MPD_CONFIG_FILE
sed -i 's/MPD_RADIO_STREAMER_HTTPD_ALWAYS_ON/'"$httpd_always_on"'/g' $MPD_CONFIG_FILE
sed -i 's/MPD_RADIO_STREAMER_HTTPD_TAGS/'"$httpd_tags"'/g' $MPD_CONFIG_FILE

if ! [ -z "${httpd_format}" ]; then
  sed -i 's/#format/'"format "'/g' $MPD_CONFIG_FILE
  sed -i 's/MPD_RADIO_STREAMER_HTTPD_FORMAT/'"$httpd_format"'/g' $MPD_CONFIG_FILE
fi

cat $MPD_CONFIG_FILE

echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
sleep $STARTUP_DELAY_SEC

echo "Creating playlist file"
echo $MPD_RADIO_STREAMER_URL#$radio_name > $PLAYLIST_BUILD_FULL_PATH
chmod 644 $PLAYLIST_BUILD_FULL_PATH

echo "Config file [$MPD_CONFIG_FILE]"
cat $MPD_CONFIG_FILE

cp $PLAYLIST_BUILD_FULL_PATH $PLAYLIST_PATH
echo "Playlist:"
cat $PLAYLIST_PATH/$PLAYLIST_FILE_NAME

echo "Ready to start."
/usr/bin/mpd $MPD_CONFIG_FILE

echo "Emptying playlist ..."
/usr/bin/mpc clear
echo "Adding playlist radio ..."
/usr/bin/mpc load radio
echo "Setting repeat mode ..."
/usr/bin/mpc repeat on
echo "Waiting ..."
sleep 1

echo "Press [CTRL+C] to stop..."
counter=0
while true
do
  counter=counter+1
  if ! mpc status | awk 'NR==2' | grep playing > /dev/null; then 
    mpc play
  fi
  sleep 5
done
