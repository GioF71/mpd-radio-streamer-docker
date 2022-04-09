# mpd-radio-streamer-docker - a Docker image for a simple mpd radio streamer

## Available Archs on Docker Hub

- linux/amd64
- linux/arm/v7
- linux/arm64/v8

## Reference

First and foremost, the reference to the awesome project:

[Music Player Daemon](https://www.musicpd.org/)

## Links

Source: [GitHub](https://github.com/giof71/mpd-radio-streamer-docker)  
Images: [DockerHub](https://hub.docker.com/r/giof71/mpd-radio-streamer)

## Why

There are a few radios I listen to, that are not available on the shoutcast and TuneIn directories.  
Sometimes those URL do not work when added directly to Logitech Media Server. This happens at least for my favourite radio, which I could not listen through Logitech Media Server / SqueezeLite.  
If you know the public URL of one of those radio, you can create a local/network streamer so you can make those radios available to other MPD instance, of maybe to Logitech Media Server.

## Prerequisites

You need to have Docker up and running on a Linux machine, and the current user must be allowed to run containers (this usually means that the current user belongs to the "docker" group).

You can verify whether your user belongs to the "docker" group with the following command:

`getent group | grep docker`

This command will output one line if the current user does belong to the "docker" group, otherwise there will be no output.

The Dockerfile and the included scripts have been tested on the following distros:

- Manjaro Linux with Gnome (amd64)
- Raspberry Pi 3/4 buster (arm32)

As I test the Dockerfile on more platforms, I will update this list.
These are the platforms I tested, but I believe the image would work also on arm64.

## Get the image

Here is the [repository](https://hub.docker.com/repository/docker/giof71/mpd-radio-streamer) on DockerHub.

Getting the image from DockerHub is as simple as typing:

`docker pull giof71/mpd-radio-streamer:stable`

You may want to pull the "stable" image as opposed to the "latest".

## Usage

### Environment Variables

Variable|Default|Notes
:---|:---:|:---
MPD_RADIO_STREAMER_URL||The URL of your radio (this is mandatory)
MPD_RADIO_STREAMER_URL|Radio|The name of the Radio
MPD_RADIO_STREAMER_HTTPD_ALWAYS_ON|yes|If set to yes, then MPD attempts to keep this audio output always open. This may be useful for streaming servers, when you don’t want to disconnect all listeners even when playback is accidentally stopped.
MPD_RADIO_STREAMER_HTTPD_TAGS|yes|If set to no, then MPD will not send tags to this output. This is only useful for output plugins that can receive tags, for example the httpd output plugin.
MPD_RADIO_STREAMER_HTTPD_FORMAT||The output format (for example, 44100:16:2 for cd quality audio format)
STARTUP_DELAY_SEC|0|Delay in sec before starting the application.

### Available Ports

Port|Description
:---|:---
8000|HTTPD streaming port

### Sample docker run

```text
docker run \
  --name mpd-deejay \
  --rm -it \
  -p 8000:8000 \
  -e MPD_RADIO_STREAMER_URL=http://myradio.com \
  -e MPD_RADIO_STREAMER_NAME=MyRadio \
  -e MPD_RADIO_STREAMER_HTTPD_ALWAYS_ON=n \
  giof71/mpd-radio-streamer
```

### Sample docker-compose

```text
---
version: '3'

services:
  mpd-streamer-radio-deejay:
    image: giof71/mpd-radio-streamer
    container_name: mpd-streamer-radio-deejay
    ports:
      - 8000:8000
    environment:
      - MPD_RADIO_STREAMER_URL=http://myradio.com
      - MPD_RADIO_STREAMER_NAME=MyRadio
      - MPD_RADIO_STREAMER_HTTPD_ALWAYS_ON=yes
      - MPD_RADIO_STREAMER_HTTPD_TAGS=yes
```

You can then listen at the url `http://your-pc-ip-address-or-hostname:8000`.  
If you have a domain name you own, you can also consider creating a HTTPS termination, so maybe you can obtain an easy to remember URL, like `https://myradio.yourdomain.com` without an explicit port number.

## Build

You can build (or rebuild) the image by opening a terminal from the root of the repository and issuing the following command:

`docker build . -t giof71/mpd-radio-streamer`

It will take very little time even on a Raspberry Pi. When it's finished, you can run the container following the previous instructions.  
Just be careful to use the tag you have built.

## Release History

Release Date|Major Changes
:---|:---
2022-04-09|Removed redundancies in start script
2022-04-09|mpd-base-image recently bumped
2022-04-08|Initial release
