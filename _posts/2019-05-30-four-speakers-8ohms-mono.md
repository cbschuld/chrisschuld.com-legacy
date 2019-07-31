---
title: Wiring 4 - 8Ω speakers to create a single 8Ω input (serial/parallel)
layout: post
tags: home-automation audio
---

When I was designing my <a href="/2019/05/whole-house-audio/">Whole House Audio Solution</a> I had three locations in my house where I wanted four speakers and the idea of having stereo sound was not important because of the location.  I wanted single-voice / mono to all four speakers - the question was *how do I wire this?*  The speakers I purchased where all 8" [Polk 80i](https://amzn.to/2IRW2WA) 8Ω speakers.  The controller / amp I purchased from monoprice supported both 4Ω and 8Ω impedance speakers.  However, in bridge mode it wanted 8Ω impedance.  How do I create 8Ω out of four 8Ω speakers?

The controller's manual is located here: [https://downloads.monoprice.com/files/manuals/10761_Manual_141028.pdf](https://downloads.monoprice.com/files/manuals/10761_Manual_141028.pdf)

A few things to note:

+ I wanted single voice
+ The amp supports bridging to create a single 100w into an 8Ω speaker
+ I could not bridge with 4Ω speakers

<img src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/rear-panel-monprice-controller.png"/>

Here is how I created a single 8Ω input with four different 8Ω speakers.

I wired all four of them in a series / parallel configuration using this schematic:

<img src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/four-speakers-serial-parallel-8ohms.png" />

This provides you 8Ω to the Amp while using four speaker in single-voice/mono.
