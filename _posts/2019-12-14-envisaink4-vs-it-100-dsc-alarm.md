---
title: EnvisaLink4 (EVL-4E) vs IT-100
layout: post
tags: home-automation home-assistant dsc
---

The DSC alarm panel is easily one of my favorite things to use with home automation.  It is a source of inexpensive motion sensors, entry points and overall presence detection.  There are two primary ways to get signal out of the DSC alarm: the [EnvisaLink 4](https://amzn.to/2PpdjLv) and the [IT-100](https://amzn.to/35nSvt8).

## IT-100

The IT-100 board is an interface board that translates keypad bus data from the DSC into an API you can interact with via RS-232 serial.

To install you add the IT-100 to the keypad bus, it will show up as keypad #8 on the bus and you can immediately receive and send status and commands on the RS-232 serial via a DB9 connector.  Overall setup is not hard and it was always responsive at boot / power up.

[IT-100 Manual](https://cms.dsc.com/download.php?t=1&id=16238)

## EnvisaLink 4 (the EVL-4E)

The EnvisaLink 4 is an interface board which translates keypad bus data into a web service.  You can interact with it via HTTP.

To install the EVL-4E you add it to the keypad bus, it will show up as keypad #8 as well (just like the IT-100) and you can begin the setup process.  It will use DHCP to find an IP address on your network and you can immediately hit the web interface for it.  (default username and password are "user")

#### Common Questions about the EVL-4E:

**Q:** Do I need to pay a monthly fee to use it?
**A:** No, you can interface with it directly on your local network.

**Q:** Does it need to be in the DSC box?
**A:** No, you can run a keypad bus 4-pair wire to where you want to EVL-4E to live.

## Background

I have two different DSC setups: one on a primary residence and one on a second home I visit infrequently.  Because I am not at the second home often remote access and stability were important to me.  At my primary residence my alarm had an IT-100 board in it because that is what the installer added.  My secondary residence did not have an IT-100.  I took that opportunity to purchase an EVL-4E.  I have used both of them for one calendar year.

## IT-100 Setup and WTF did it go?

My IT-100 is decorated with a DB9 serial cable to a Raspberry Pi computer.  I [wrote up the details on how I decorate the system](/2019/02/home-assistant-to-dsc-alarm-with-an-it-100/) on the Raspberry Pi.  The problem I am consistently running into is the disappearance of the IT-100's serial interface.  It will simply disappear.  Without any clear warning I will be unable to communicate with the serial interface.  If I bounce the DSC alarm it will immediately come back and be stable for weeks.  I have even tested the serial scenario on the Pi as well and it is fine.  Mr. IT-100 where did you go?

## EnvisaLink4 and Stability

The EnvisaLink4 is by far more stable than the IT-100 serial interface.  I have yet to have to kick the panel to bring back the EVL-4E.  It simply "just works."

## EyezOn

The EyezOn system, which is essentially the mothership for the EnvisaLink4, is also not bad for the monthly price of $0.00.  It provides a fast way to check in on the device and it also provides a quick way to make sure it is working during debug.

## Forget it... get me another EVL-4E

This Black Friday I gave in and got another [EVL-4E](https://amzn.to/2PpdjLv) for my primary residence.  My relationship with the IT-100 has come to an end.

If you are using Home Assistant or really any type of external monitoring for your DSC go with the [EVL-4E](https://amzn.to/2PpdjLv) and skip the fight with the IT-100.

## TLDR

The EnvisaLink EVL-4E is the steady winner.  It costs about two times what the IT-100 board does but you'll likely need to decorate in front of it with a Raspberry Pi and thus the costs are about equivalent.  I am currently running two different EVL-4Es (one at each home) and I am happy with them.  They do not "fall off the network" nor do I have to fight the continuous stream of WTF from the IT-100 serial connection.  **If you do not own either of them; just get the [EnvisaLink 4](https://amzn.to/2PpdjLv).**  The clear winner.