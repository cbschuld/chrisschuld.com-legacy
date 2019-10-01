---
title: Updating Home Assistant with Docker
layout: post
tags: docker home-automation home-assistant
---

When I was leaving the world of [HASSIO](https://www.home-assistant.io/hassio/) I read that one of the things it does for you is update home assistant easily.  :unamused:

Updating Home Assistant with Docker is **EASY** stuff!

## My Setup

Here is what my docker looks like locally:

```bash
pi@ha:~ $ docker ps -a
CONTAINER ID        IMAGE                                             COMMAND                  CREATED             STATUS                    PORTS               NAMES
7e5316b433f1        homeassistant/raspberrypi4-homeassistant:latest   "/bin/entry.sh pytho…"   53 seconds ago      Up 51 seconds (healthy)                       homeassistant
pi@ha:~ $
```

## Updating...

With Docker-Compose:
```bash
docker-compose down
docker-compose pull
docker-compose up
```

With Docker:
```bash
docker stop homeassistant
docker pull homeassistant/raspberrypi4-homeassistant:latest
docker start homeassistant
```
