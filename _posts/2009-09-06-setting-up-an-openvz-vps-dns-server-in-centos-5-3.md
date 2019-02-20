---
title: Setting up an OpenVZ VPS DNS Server in CentOS 5.3
layout: post
tags: centos openvz
---
Here is my quick-and dirty way to build DNS servers using OpenVZ, CentOS and Bind/Named.  This assumes you are creating a new server via OpenVZ.  Although Bind is easy to admin with the configuration files recently I have found it is easier to simply admin the zones with Webmin.  This setup will create the VPS, install Bind and install Webmin.

Create the VPS:
{% highlight bash %}
cid=1161
cd /vz/template/cache/
wget http://download.openvz.org/template/precreated/centos-5-x86_64.tar.gz
vzctl create ${cid} --ostemplate centos-5-x86_64 --config vps.basic
vzctl set ${cid} --hostname [HOSTNAMEHERE] --save
vzctl set ${cid} --ipadd [IP] --save
vzctl set ${cid} --nameserver [IP] --save
vzctl start ${cid}
vzctl exec ${cid} passwd
vzctl enter ${cid}
{% endhighlight %}

From inside the VPS I install bind and webmin
{% highlight bash %}
yum -y install bind bind-chroot bind-libs bind-utils caching-nameserver
cd /root
wget http://prdownloads.sourceforge.net/webadmin/webmin-1.480-1.noarch.rpm
rpm -Uvh webmin-1.480-1.noarch.rpm
{% endhighlight %}

Now I simply visit webmin's panel and tap in any new zones (<em>or copy over our zones from another box</em>).

OpenVZ and virtual serving makes this time-consuming task of bringing new boxes up a simple task!
