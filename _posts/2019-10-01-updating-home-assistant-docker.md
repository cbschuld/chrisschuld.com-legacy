---
title: Updating Home Assistant with Docker
layout: post
tags: docker home-automation home-assistant
---

When I was exiting the world of [HASSIO](https://www.home-assistant.io/hassio/) I read one of the major benefits is updating.  Was updating hard?  I found out it was not. :unamused:

Turns out... updating Home Assistant with Docker is **EASY** stuff!

## My Setup

Here is what my docker looks like locally:

```
pi@ha:~ $ docker ps -a
CONTAINER ID  IMAGE                                            STATUS                   NAMES
7e5316b433f1  homeassistant/raspberrypi4-homeassistant:latest  Up 51 seconds (healthy)  homeassistant
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
