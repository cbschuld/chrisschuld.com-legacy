---
title: Installing vzdump on CentOS 5.4 (32-bit)
layout: post
tags: openvz
---

There are a few items required for installing vzdump for OpenVZ on 32bit CentOS.

First, make sure you read the installation post covering the 64bit install. Here are the commands for 32bit. Here is how you get vzdump on a clean version of 32bit CentOS (via the hostnode):

{% highlight bash %}
rpm -ivh "ftp://ftp.pbone.net/mirror/ftp.freshrpms.net/pub/freshrpms/pub/dag/redhat/el5/en/i386/RPMS.dag/cstream-2.7.4-3.el5.rf.i386.rpm"
wget http://dag.wieers.com/rpm/packages/perl-LockFile-Simple/perl-LockFile-Simple-0.206-1.el5.rf.noarch.rpm
rpm -ivh perl-LockFile-Simple-0.206-1.el5.rf.noarch.rpm
/bin/rm perl-LockFile-Simple-0.206-1.el5.rf.noarch.rpm
rpm -ivh "http://chrisschuld.com/centos54/vzdump-1.2-6.noarch.rpm"
{% endhighlight %}

Make sure you add in the PERL5LIB in your export (see the [64bit post](http://{{ site.url }}/installing-vzdump-for-openvz-on-centos/)):

{% highlight bash %}
export PERL5LIB=/usr/share/perl5/
{% endhighlight %}