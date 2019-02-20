---
title: How to install &quot;dig&quot;&#58; -bash&#58; &#47;usr&#47;bin&#47;dig&#58; No such file or directory
layout: post
tags: centos
---

If you are missing the dig command it means you are missing a package called bind-utils.  To install this package use yum to install bind utils:

{% highlight bash %}
yum install bind-utils
{% endhighlight %}

Or if you do not have access to yum, maybe from a hosted VPS solution you can grab the RPM packages (this is 100% assuming you are CentOS):

{% highlight bash %}
rpm -i http://mirror.centos.org/centos/5/os/i386/CentOS/bind-utils-9.3.4-6.P1.el5.i386.rpm
{% endhighlight %}

Or maybe you want to install the entire bind/named system:

{% highlight bash %}
rpm -i http://mirror.centos.org/centos/5/os/i386/CentOS/bind-9.3.4-6.P1.el5.i386.rpm
rpm -i http://mirror.centos.org/centos/5/os/i386/CentOS/bind-chroot-9.3.4-6.P1.el5.i386.rpm
rpm -i http://mirror.centos.org/centos/5/os/i386/CentOS/bind-libs-9.3.4-6.P1.el5.i386.rpm
rpm -i http://mirror.centos.org/centos/5/os/i386/CentOS/caching-nameserver-9.3.4-6.P1.el5.i386.rpm
rpm -i http://mirror.centos.org/centos/5/os/i386/CentOS/bind-utils-9.3.4-6.P1.el5.i386.rpm
{% endhighlight %}
