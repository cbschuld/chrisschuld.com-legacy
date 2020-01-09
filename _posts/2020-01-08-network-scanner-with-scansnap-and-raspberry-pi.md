---
title: Network Scanner with Fujitsu ScanSnap and a Raspberry Pi
layout: post
tags: pi linux home-automation
---

My trusty Fujitsu ScanSnap S1500 had to be tossed aside when MacOS Catalina ditched the 32bit libraries.  It sat lifeless on my desk until I realized I could use a Raspberry Pi to bring it back to life as a headless network scanner.

## Thinking through this...

If I could plug the ScanSnap into a Raspberry Pi, capture the scan button depressions on the device, get the scanned content converted to PDF and loaded to some shared drive it would be the perfect solution.

## Solution Summary

+ Install [Raspbian Lite](https://www.raspberrypi.org/downloads/raspbian/)
+ Install [SANE](http://www.sane-project.org/) and [sanebd](https://wiki.archlinux.org/index.php/Scanner_Button_Daemon)
+ Configure sanebd (for button pushing/polling)
+ Install and configure [Samba](https://www.samba.org/) locally and share to the network from the Pi directly

## Solution Walk-through

Here was my process to make the network scanner work!  Everything lives in the `pi` user's home directory/space and the Samba share runs from there as well.  Trying keep it as KISS-focused as possible.

+ Using a Raspberry Pi 3B+ I [installed Raspbian Lite](https://www.raspberrypi.org/downloads/raspbian/) (*now that I have used the PI4 for other projects I wish I had a bucket of those lying around*).
+ Added [SSH](https://www.raspberrypi.org/documentation/remote-access/ssh/) connectivity via `raspi-config`

## Software Install

Install all of the software necessary for the system:

```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt install sane sane-utils scanbd git imagemagick -y
```

## Scanner Check

We add the pi user into the scanner group and then we check to make sure the scanner is working after the SANE install.  (*before this step; put a piece of paper in the scanner and open her lid*)

```bash
sudo usermod -a -G scanner pi
sudo scanimage >/tmp/out.pnm
```

now, `/tmp/out.pnm` will have the scan from the scanner

## Scan App

There is a cool script made by Raman Gupta at [https://github.com/rocketraman/sane-scan-pdf](https://github.com/rocketraman/sane-scan-pdf).  Configuring all of the scanimage/scan calls can be time consuming; Raman has wrapped it all and I found it to be useful (*minus an issue on RPI that I reported*).
```bash
cd $HOME
git clone https://github.com/rocketraman/sane-scan-pdf.git
```

## Create a shared space for the scans via Samba Share

We need a spot to keep the scans on the local system and share them out via SMB.

```bash
cd $HOME; mkdir scans
chmod 777 scans
smbpasswd -a pi
```

Next, I added the following to `/etc/samba/smb.conf`

```ini
    [scans]
        valid users = pi
        path = /home/pi/scans
        writeable = yes
        create mask = 0777
        directory mask = 0777
        public = no
```

## Scanbd - "the scan button"

Next, we need to listen for the scan button.  Thankfully there is `scanbd` which will do this for us.

First, I update `/etc/scanbd/scanbd.conf` by setting

`scriptdir=/etc/scanbd/scripts`

and in

`action scan` I add this:
```
    desc = "Scan to file and share"
    script = "scan.sh"
```

Finally, I create `scan.sh` as (`vi /etc/scanbd/scripts/scan.sh`):

```bash
#!/bin/sh
now=`date +"%Y-%m-%d-%H%M"`
/home/pi/sane-scan-pdf/scan -d -r 300 -v -m Lineart --skip-empty-pages -o /home/pi/scans/scan-$now.pdf
```

## Done!

Now when push the scan button; the ADF scanner runs and the PDF appears in the shared drive!  Magic!

Special thanks [Phillipp Keller](http://howto.philippkeller.com/2018/02/08/Scan-with-raspberry-pi-convert-with-aws-to-searchable-PDF/) for his write up on his network scanner to S3.  I learned a lot from his fight and worked from it.

