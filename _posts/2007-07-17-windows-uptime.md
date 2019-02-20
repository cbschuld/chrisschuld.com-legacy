---
title: Windows "uptime"
layout: post
tags: windows
---

For users of linux and unix one command which is useful is <i>uptime</i>.  The <i>uptime</i> command allows you to view the amount of time the server has been running since its last reboot or cold start.  If you are administering a Windows machine there is no <i>uptime</i> command -- however; this trick will give you a similar result!

I present "uptime" for Windows:

{% highlight bash %}
net statistics server
{% endhighlight %}
PS: to run this click on Start&#45;&#45;&#62;Run and enter CMD -- hit enter and then type "net statistics server" into the MS-DOS emulated window and hit enter.