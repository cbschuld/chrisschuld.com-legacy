---
title: 
layout: 
tags: 
---

I have a DSC alarm at my house and I want to use Home Assistant to work with it.  I purchased the IT-100 board and then decided I wanted to expand it a bit further.  The company who originally installed the alarm did not record the installer's code when they installed it so I was up a creek as far as knowing the installer code.  I quickly realized I could use the IT-100 board and some time to systematically determined the installer code but the time spent on that would be spent only because I had some concerns regarding reprogramming it.

> Sorry man, there's no notes in your file for the installer code.

I decided to reprogram it myself and here are my notes for anyone attempting to reprogram their own DSC alarm.  The process is incredibly straight forward with only a few caveats.

First, you need to factory reset the sucker.  You have to short the zone 1 with the PGM1 pin.  Thus, you have to ground Z1 to PGM and power the system up for 10 seconds and then power it off, remove the jumper and then power it back on.  This works 100% like the manual describes:




