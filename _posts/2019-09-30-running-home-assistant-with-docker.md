---
title: Running Home Assistant with Docker (docker-compose)
layout: post
tags: docker home-automation home-assistant
---

[Home Assistant](https://www.home-assistant.io/0) on [Docker](https://www.docker.com/) is easier than running it with [HASSIO](https://www.home-assistant.io/hassio/) IMO.  :rocket:

Here is a high-altitude overview of how I run Home Assistant -and- then I'll dig into the details of my setup.
+ Setup Raspbian with Docker and Docker-Compose
+ Plugin my Aeon Z-wave script; make sure it's on /dev/ttyACM0
+ Setup scripts for Docker-Compose
+ Setup scripts so it runs on startup
+ Create a backup process

Okay, details... here is how I run Home Assistant on Docker on a Raspberry Pi 4.

+ Install [Raspbian](https://www.raspberrypi.org/downloads/raspbian/) on the Raspberry Pi 4.
+ Install [Docker and Docker-Compose](https://chrisschuld.com/2019/09/installing-docker-and-docker-compose-on-raspberry-pi4-with-raspian/).
+ Create /root/docker-compose.yml consisting of the following (*NOTE: I use the Aeon z-wave stick at /dev/ttyACM0*):

```yaml
version: '3.7'
services:
  homeassistant:
    container_name: homeassistant
    image: homeassistant/raspberrypi4-homeassistant:latest
    network_mode: "host"
    ports:
      - "8123:8123"
    volumes:
      - /opt/homeassistant:/config
      - /etc/localtime:/etc/localtime:ro
      - /etc/letsencrypt:/etc/letsencrypt:ro
    devices:
      - /dev/ttyACM0:/dev/ttyACM0:rwm
    restart: always
    healthcheck:
      test: ["CMD", "curl", "-f", "http://127.0.0.1:8123"]
      interval: 30s
      timeout: 10s
      retries: 6
```

+ Create the following file for automating the service on startup `/etc/systemd/system/home-assistant.service`

```ini
# /etc/systemd/system/home-assistant.service

[Unit]
Description=Home Assistant Service
Requires=docker.service
After=docker.service

[Service]
WorkingDirectory=/root
ExecStart=/usr/local/bin/docker-compose up
ExecStop=/usr/local/bin/docker-compose down
TimeoutStartSec=0
Restart=on-failure
StartLimitIntervalSec=60
StartLimitBurst=3

[Install]
WantedBy=multi-user.target
```

+ Run this `systemctl enable home-assistant.service`
+ Run this `systemctl enable docker`

