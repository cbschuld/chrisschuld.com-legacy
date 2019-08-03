---
title: Decorating the Monoprice 6 Zone Home Audio Multizone Controller
layout: post
description: How to use an inexpensive Raspberry Pi to give your Amp a JSON API
tags: home-automation
---

<img src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/monoprice-six-zone-amp-rear.png" style="width:400px;float:right;"/>

Monoprice sells this inexpensive six zone home audio controller that provides a lot of value for the price point.  [I use two them in my setup](/2019/05/whole-house-audio/) and thus far have had a great experience with them (I purchased them in 2015).  The only down side is controlling them both from my phone as well as from my home automation system.

### Question: how are we going to talk to this thing...

The amp controllers have a DB9 serial port on the back that allows you to communicate with a serial protocol built into the controller.  You can read more about the grainy details of the serial protocol it in the manual if you are intereted but if you decorate her you will not care *([device manual](https://downloads.monoprice.com/files/manuals/10761_Manual_141028.pdf))*.  The next problem is turning the DB9 serial connectivity - we need to conver that into something more usable on our network.  The solution is to plop a JSON API in front of it.  We do that by decorating her...

### Time to decorate

There are a few different ways to decorate infront of the Monoprice 6 Zone Home Audio Multizone Controller but I think the easiest, by far, is to use an inexpensive [Raspberry Pi](https://amzn.to/2Xk58og).  On the Raspberry PI I run a service that turns the DB9 serial into a JSON web API.

You will absolutely need a serial cable to USB (DB9 to USB) and it must have the PL-2303 Chipset to work.  This one works great - [USB 2.0 to RS232 DB9 Serial Cable Male A Converter Adapter with PL2303 Chipset](https://amzn.to/2ypmceB)

### What do I need
+ [Raspberry Pi](https://amzn.to/2Xk58og)
  + [Raspberry Pi Starter Kit - everything you need](https://amzn.to/33cXPz4)
+ [USB 2.0 to RS232 DB9 Serial Cable Male A Converter Adapter with PL2303 Chipset](https://amzn.to/2ypmceB)

### Jesse Newland's API 

I started working on my own API for the serial connection and bumped into Jesse's solution in Node and stopped working on mine and used his.  Jesse had a single amp so I was able to help add the secondary amp controls to his API.  He saved me a lot of time!

You can find more information about Jesse's API here: [https://github.com/jnewland/mpr-6zhmaut-api](https://github.com/jnewland/mpr-6zhmaut-api)

I maintain a fork of Jesse's project here: [https://github.com/cbschuld/mpr-6zhmaut-api](https://github.com/cbschuld/mpr-6zhmaut-api)

However, you will not have to get very involved in the API because I'll show you how to get it running without a lot of trouble.

### Enough, let's set this up...

#### Install Raspian Lite

I install [Raspian](https://www.raspberrypi.org/downloads/raspbian/) on my Pi for the decorator and I generally prefer to use the lite image.

You'll have to etch/write the image to the SD card and there are a TON of sites that will help you do this and there is a TON of info on the Raspian site.  Install the OS onto the SD card and boot it up.

Post boot; here's the process...

#### Enable SSH

+ Enter `sudo raspi-config` in a terminal window
+ Select **Interfacing Options**
+ Navigate to and select **SSH**
+ Choose **Yes**
+ Select **Ok**
+ Choose **Finish**

Now you can SSH to the command line and relocate the Pi to your controller.  There are other paths to get SSH running but this is the simplist out of the box.

#### Reset the Default Password

The default password on the Raspbian OS is "raspberry" for the user "pi" - you can change that with the `passwd` command and that is something you should do right away.

```bash
passwd
```

#### Update the Raspbian Install

Next, we will update the Raspbian install and we will install some missing software that we need

```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install git npm
sudo npm install npm@latest -g
sudo npm install -g node-gyp
sudo npm install -g node-pre-gyp
```

#### Add the JSON API

I am currently using my fork for Jesse's API:

```bash
cd ~
git clone https://github.com/cbschuld/mpr-6zhmaut-api.git
cd ~/mpr-6zhmaut-api
npm install
```

#### Make the multizone API a service so it starts on reboot

```bash
sudo vi /etc/systemd/system/multizone-server.service
```

where the file `/etc/systemd/system/multizone-server.service` contains the following:
```
[Unit]
Description=Monoprice Multizone Controller Service

[Service]
ExecStart=/usr/bin/node /home/pi/mpr-6zhmaut-api/app.js
WorkingDirectory=/home/pi/mpr-6zhmaut-api/
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
#SyslogIdentifier=nodejs-example
#User=<alternate user>
#Group=<alternate group>
Environment=PORT=8181 AMPCOUNT=2 REQUERY=true CORS=true

[Install]
WantedBy=multi-user.target
```
**Notes:**
+ Make sure you include the correct AMPCOUNT, my setup has two amps - simply an integer (default 1)
+ Do you use the keypads?  If yes, I would highly suggest using REQUERY=true
+ Plan on accessing the API from another host?  If so, make sure you set CORS to true.

Next, let's enable the service:

```bash
sudo touch /etc/default/multizone-server
echo PORT=8181 | sudo tee -a /etc/default/multizone-server
echo DEVICE=/dev/ttyUSB0 | sudo tee -a /etc/default/multizone-server
echo NODE_ENV=production | sudo tee -a /etc/default/multizone-server
sudo systemctl enable multizone-server
sudo systemctl start multizone-server
```

#### That was easy, let's test

Now your service should be running so you can query it directly.  Here is an example to turn on zone 16 (zone six of amp1) assuming your Raspberry Pi is at 10.0.0.10
```bash
curl -XPOST -d 01 10.0.0.10:8181/zones/16/pr
```

