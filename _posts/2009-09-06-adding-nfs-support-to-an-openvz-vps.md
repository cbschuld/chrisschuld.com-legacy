---
title: Adding NFS support to an OpenVZ VPS
layout: post
tags: centos openvz
---

I still use a lot of NFS connections on my equipment and when I create OpenVZ VPS systems I need them to have access to NFS.  Here are the steps I use:

From the Host Node (HN):
{% highlight bash %}
modprobe nfs
vzctl set 101 --features "nfs:on" --save
{% endhighlight %}

From the VPS:
{% highlight bash %}
yum -y install nfs-utils nfs-utils-lib
chkconfig --levels 345 portmap on
/etc/init.d/portmap start
{% endhighlight %}