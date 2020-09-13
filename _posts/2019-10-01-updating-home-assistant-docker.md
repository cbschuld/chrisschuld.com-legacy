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

In order to update you'll need to know where your `docker-compose.yml` file is located.  Simply change to the directory with the `docker-compose.yml` and do the following:

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

## My personal solution...

I have the following `update.sh` script in my `/root` folder that I use to accelerate the update process.  To run it I jump into root with `sudo su -` and then `cd $HOME && ./update.sh`:

```bash
#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

cd /root/homeassistant/
docker-compose down &&  docker-compose pull &&  reboot
```