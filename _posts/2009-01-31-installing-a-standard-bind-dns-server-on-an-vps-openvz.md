---
title: Installing a standard Bind DNS server on an VPS (openvz)
layout: post
tags: linux centos
---

All of our name servers I use are virtual servers and we add them into our network as OpenVZ VPS systems.  Here is the setup I use for setting up a Bind server on an OpenVZ VPS with CentOS 5.

Setup the Open VZ VPS and get into the VPS:
{% highlight bash %}
vzctl create 1031 --ostemplate centos-5-i386-default --config vps.basic
vzctl set 1031 --hostname ns4.aztecsoftware.net --save
vzctl set 1031 --ipadd 10.0.0.31 --save
vzctl set 1031 --nameserver 10.0.0.30 --save
vzctl start 1020
vzctl enter 1020
{% endhighlight %}

Now that you are in the VPS update the OS and get Bind updated:
{% highlight bash %}
yum -y erase bind* caching-nameserver
rm -rf /var/named
yum -y install bind*
yum -y update
{% endhighlight %}


Get the DNS key through dns-keygen (<em>copy the key</em>):

{% highlight bash %}
/usr/sbin/dns-keygen
{% endhighlight %}

Start the DNS Setup:

{% highlight bash %}
touch /var/named/chroot/etc/named.external.zones
touch /var/named/chroot/etc/named.internal.zones
cp /usr/share/doc/bind-9.3.4/sample/etc/named.* /var/named/chroot/etc/
cp /usr/share/doc/bind-9.3.4/sample/var/named/named.root /var/named/chroot/var/named/
chown named:named /var/named/chroot/var/named/named.root
{% endhighlight %}

I am not going to get into details on how to setup your named.conf -- as mainly this is a command reference for myself in the future (<em>aren't I selfish</em>).  However, here is my list:
<ul><li>Remove the Caching Server View (localhost_resolver) because we do not need it because we are not using the caching only name server</li>
<li>Setup the zones for internal and external and point them to the touched files above (named.external.zones and named.internal.zones)</li>
<li>Make sure you are not in a position where you can fall subject to the <a href="http://howtoforge.com/how-to-patch-bind-to-avoid-cache-poisoning-fedora-centos">cache poison</a>.</li>
</ul>

{% highlight bash %}
vi /var/named/chroot/etc/named.conf
{% endhighlight %}