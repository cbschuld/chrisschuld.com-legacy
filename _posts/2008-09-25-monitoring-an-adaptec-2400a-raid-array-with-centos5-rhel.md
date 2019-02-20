---
title: Monitoring an Adaptec 2400a RAID ARRAY with CentOS5 (RHEL)
layout: post
tags: linux
---

I have two older machines with Adaptec 2400A RAID cards in them which recently both got upgraded to CentOS5.  The first task was to figure out how to monitor the arrays.  CentOS 5.2 went in without a problem but getting information about the status of the disks from the array was not easy and google was little help (at the time).

Here is how you monitor the array using raidutil if you have the older Adaptec 2400a card:

Install raidutil&#58;
{% highlight bash %}
wget "http://i2o.shadowconnect.com/raidutils/raidutils-0.0.6-1.i386.rpm"
rpm -Uvh raidutils-0.0.6-1.i386.rpm
{% endhighlight %}

Next, add the dev control structures so raidutil knows what to do with the card when it queries it

{% highlight bash %}
mknod /dev/i2o/ctl c 10 166
mknod /dev/dpti17 c 10 166
modprobe i2o_config
{% endhighlight %}

Now, you can query your controller&#58;
{% highlight bash %}
 raidutil -L all
 raidutil -L physical
{% endhighlight %}