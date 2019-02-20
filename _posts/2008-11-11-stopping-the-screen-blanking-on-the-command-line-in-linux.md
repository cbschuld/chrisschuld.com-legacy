---
title: Stopping the screen blanking on the command line in linux
layout: post
tags: linux
---

We have a server in my office we reference a lot.  After X time period it would fall asleep and someone would have to hit the keyboard to see the latest information.  After digging for a bit (and never really finding the answer) I figured it out and decided to document it because I will forget next time this occurs!

{% highlight bash %}

setterm -blank 0
setterm -powersave off

{% endhighlight %}

You have to do this from the terminal console and not a remote shell (which, would actually make no sense) or you will see this message:

{% highlight bash %}
cannot (un)set powersave mode
{% endhighlight %}