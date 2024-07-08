FROM python:3.11-bookworm

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --yes --no-install-recommends alsa-utils pulseaudio

WORKDIR /app

COPY script/setup ./script/
COPY setup.py requirements.txt MANIFEST.in ./
COPY wyoming_snd_external/ ./wyoming_snd_external/

RUN script/setup
RUN echo load-module module-role-ducking trigger_roles=phone ducking_roles=music volume=0.0 >> /etc/pulse/default.pa

COPY script/run ./script/
COPY docker/run ./

EXPOSE 10601

ENTRYPOINT ["/app/run"]
