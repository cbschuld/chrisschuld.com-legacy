---
title: Programming a DSC 1832 Alarm (or re-programming)
layout: post
tags: ha dsc
---

I have a DSC alarm at my house (a [PC1832](https://amzn.to/2XlajBG)) and I want to use [Home Assistant](https://www.home-assistant.io/) to work with it.  I purchased the [IT-100 board](https://amzn.to/2BPi9KB) and then decided I wanted to expand it a bit further to include more zones.  The company who originally installed the alarm did not record the installer's code when they installed it so I was up a creek as far as knowing the installer code.

> Sorry man, there's no notes in your file for the installer code.

I quickly realized I could use the [IT-100 board](https://amzn.to/2BPi9KB) and some time to systematically determine the installer code but the time spent on that would be spent only because I had some concerns regarding reprogramming it.  I decided to reprogram it myself and here are my notes for anyone attempting to program or even reprogram their own DSC alarm.  The process is incredibly straight forward with only a few caveats.

For clarity I have a [PC1832](https://amzn.to/2XlajBG) with four  keypads and I have two additional [PC5108](https://amzn.to/2Eqv9s3) expanders to give me up to 24 zones.  NOTE: if you are buying a new DSC I would suggest getting the [PK5500](https://amzn.to/2XmiDAY) keypads instead of the PK5501 keypads.  I have another system with PK5500 keypads and they are great.  Get at least one of them to help with the programming.

### Where's the manual?

[Installation Manual for the DSC PC1616 / PC 1832 / PC1864](/public/documents/PC1616-1832-1864_Installation_Manual_ENG_29008247R004.pdf)

### Let's get going

Time to factory reset the system.  To do this you have to short the zone 1 pin (not the z1 common pin) with the PGM1 pin.  Thus, you have to ground Z1 to PGM and power the system up for 10 seconds and then power it off, remove the jumper and then power it back on.  This works 100% just like the manual describes:

<img src="/public/images/dsc-factory-reset.png" class="shadow" />

Okay, now it is reset and ready for programming.  This is the first DSC alarm I have programmed so I am always open for commentary on the process.

Here is how I programmed it and the order I went through:

+ Enroll the keypads
+ Switch to normally-closed loops (non-resistive circuits)
+ Program the zones
+ Cancel the telephone system (as it is monitored via the Internet)
+ Set the partitioning for expanded zones
+ Check the devices
+ Reset the master code
+ Reset the installer code (victory)

### Items of Note
+ I programmed my system in a single partition (partition 1)
+ My alarm is monitored via the Internet and not via the telephone system(s) built into the DSC

### Enroll the Keypads
I have four keypads plus the IT-100 so my keypad bus is busy.  At each keypad I enrolled each one (one by one)
```
On Keypad #1: *8 5555 000 0 11 #
On Keypad #2: *8 5555 000 0 12 #
On Keypad #3: *8 5555 000 0 13 #
On Keypad #4: *8 5555 000 0 14 #
```

### Switch to normally-closed loops
My alarm is not UL based and is wired with normally closed loops.  You have to tell the DSC this or it will think all of the zones are in an alarm state.  The in the First Option Code group we need to make sure option 1 is on.  Thus we'll enter programming mode and enter 013 and hit 1 to enable option 1.
```
*8 5555 013 1 #
```

### Program the Zones
This is probably the most complex step in the process.  You need to map out all of your zones.  Each zone will traditionally fit into either: Delay 1 (01), Delay 2 (02), Instant (03), Interior Stay/Away (05).  Here was my table of zones and types:

| Zone | Definition |
|------|:----------:|
| 1    |  01        |
| 2    |  03        |
| 3    |  03        |
| 4    |  03        |
| 5    |  03        |
| 6    |  03        |
| 7    |  03        |
| 8    |  03        |
| 9    |  03        |
| 10   |  03        |
| 11   |  03        |
| 12   |  03        |
| 13   |  03        |
| 14   |  03        |
| 15   |  03        |
| 16   |  03        |
| 17   |  03        |
| 18   |  03        |
| 19   |  03        |
| 20   |  03        |
| 21   |  05        |
| 22   |  05        |
| 23   |  05        |
| 24   |  02        |

Programming that as follows:
```
*8 5555 001 01 03 03 03 03 03 03 03 #  (zones 1 - 8)
*8 5555 002 03 03 03 03 03 03 03 03 #  (zones 9 - 15)
*8 5555 003 03 03 03 03 05 05 05 02 #  (zones 16 - 24)
```

### Cancel the Trouble from the Telephone System

My alarm panel was in trouble mode until I told the system I will not be using the telephone system (I am monitoring it via an online service).  Therefore, I had to tell it *not* to consider the alarm in trouble mode if the telephone system was having issues in the Third System Option.
```
*8 5555 015 1 #
```

### Partitioning the zones beyond eight

Partitioning was the one step in the process that was initially confusing for me.  You have to partition the zones above eight be in the same partition as the other zones.  I have 24 zones on my system provided by the 8 default zones on the PC1832 and the 16 additional zones from the two additional [PC5108 expanders](https://amzn.to/2Eqv9s3).

Zones 9-24 need to be told to be in partition 1.

```
*8 5555 203 123456789 #
*8 5555 204 123456789 #
```

This should show each zone being added into the partition as you enter 1, 2, 3, 4, 5, ...

### Check the devices

In the manual there is a programming feature called "View Module Supervision" this allows you to see what the DSC has connected to it using this chart:

<img src="/public/images/dsc-module-supervision-903.png" class="shadow"/>

In my case I wanted to see in the display 1, 2, 3, 4, 8, 9, 10 which would represent my keypads, my IT-100 board as well as represent my two expansion / expander boards.

```
*8 5555 903 [wait for display] #
```

### Reset the Master Code

Resetting the master code is straight forward, for this example, I'll reset it to 2233
```
*8 5555 007 2233 #
```

### Reset the Installer Code

Resetting the installer code is straight forward, for this example, I'll reset it to 5566
```
*8 5555 006 5566 #
``` 

### Questions I had during the process

**Q:** Can I reset the installer code if I have access to the DSC board?  
**A:** No, it requires a hard reset

**Q:** Do I need to add resistors, all of my wiring is closed loop?  
**A:** You do not the DSC alarm can be programmed to work with normally closed loops as long as it is not a UL requirement

**Q:** How come zones 1 - 8 are working but zones 9 - 24 are not working?  
**A:** That is because they are in the wrong partition and have to be moved into partition one.  The DSC factory resets with zones 9-X in partition 0 so they do not appear in partition 1 automatically.

**Q:** The DSC alarm cannot see the zones (the zones will not chime) in my expander units - WTF?  
**A:** Initially I thought I had the jumpers wrong on the system but it turns out they were in a zero partition and using codes 202, 203 and 204 fixed that (question above)

### Hindsight

In hindsight it would have been less expensive to not purchase the [IT-100 board](https://amzn.to/2BPi9KB) and instead pick up the [Eyez-On Envisalink EVL-4EZR](https://amzn.to/2E6YINH).  The IT-100 board was fun to mess with and was somewhat nostalgic.  However, now I am decorating it with a Raspberry Pi.

