---
title: TFTP Server Logs (or lack there of)
layout: post
tags: linux
---

We have a TFTP server running on our network and sometimes we need to get a handle on the requests on the server.  By default if you are using linux and the tftp server through xinetd you won't have a log file to look at.  Thus you need to use TCPDUMP... here is how you do it:

{% highlight bash %}
tcpdump port 69 -v
{% endhighlight %}

This was really helpful for us when we were setting up our Cisco 7960 phones and needed to get a handle on what in the world the crazy Cisco firmware was even requesting!