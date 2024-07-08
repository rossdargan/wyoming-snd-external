# Wyoming External Sound

[Wyoming protocol](https://github.com/rhasspy/wyoming) server that runs an external program to play audio.

The external program must receive raw PCM audio on its standard input.
The format will match the `--rate`, `--width`, and `--channel` arguments provided to the server.

# Useful Links:
* https://github.com/mviereck/x11docker/wiki/Container-sound:-ALSA-or-Pulseaudio

Follow this guide on the docker host:-
https://github.com/FutureProofHomes/wyoming-enhancements/blob/master/snapcast/docs/2_install_pulseaudio.md

Then modify this file `nano /etc/pulse/system.pa`, and at the bottom add in this module `load-module module-native-protocol-unix socket=/tmp/pulseaudio.socket`

This is my docker compose file:
```
  playback:
    container_name: wyoming-snd-external
    build: https://github.com/rossdargan/wyoming-snd-external.git
    image: wyoming-snd-external
    restart: unless-stopped
    ports:
      - 10601:10601
    devices:
      - /dev/snd:/dev/snd
    group_add:
      - audio
      - pulse-access
    environment:
      - program=paplay --property=media.role=announce --channels=1 --raw
        --format=s16le --rate=22050 --latency-msec 1
      - PULSE_SERVER=unix:/tmp/pulseaudio.socket
    volumes:
      - /tmp/pulseaudio.socket:/tmp/pulseaudio.socket
    command:
      - --debug
```
## Installation

``` sh
script/setup
```


## Example

Run a server that plays audio with `aplay`:

``` sh
script/run \
  --uri 'tcp://127.0.0.1:10601' \
  --program 'aplay -r 22050 -c 1 -f S16_LE -t raw' \
  --rate 22050 \
  --width 2 \
  --channels 1
```
