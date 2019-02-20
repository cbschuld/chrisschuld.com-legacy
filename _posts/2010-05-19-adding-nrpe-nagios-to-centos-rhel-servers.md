---
title: Adding NRPE (Nagios) to CentOS \/ RHEL Servers
layout: post
tags: linux
---

We use [nagios](http://www.nagios.org/) to watch our networks and I always forget the simple steps necessary to drop NRPE on the virtual servers or physical services. This post is simply my process I use to drop NRPE on our servers.

{% highlight bash %}
yum install nrpe nagios-plugins-all
echo -e "nrpe\t\t5666/tcp\t\t\t# nrpe" >> /etc/services
chkconfig nrpe on
vi /etc/nagios/nrpe.cfg
/etc/init.d/nrpe start
{% endhighlight %}