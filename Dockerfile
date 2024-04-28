FROM python:3.11-slim-bookworm

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --yes --no-install-recommends alsa-utils pulseaudio pulseaudio-utils

WORKDIR /app

COPY script/setup ./script/
COPY setup.py requirements.txt MANIFEST.in ./
COPY wyoming_snd_external/ ./wyoming_snd_external/

RUN script/setup

RUN echo load-module module-alsa-sink device=hw:0,0 >> /etc/pulse/default.pa && \
    echo load-module module-alsa-source device=hw:0,0 >> /etc/pulse/default.pa && \
    echo load-module module-native-protocol-unix >> /etc/pulse/default.pa && \
    echo load-module module-native-protocol-unix auth-anonymous=1 >> /etc/pulse/system.pa

COPY script/run ./script/
COPY docker/run ./

EXPOSE 10601

ENTRYPOINT ["/app/run"]
