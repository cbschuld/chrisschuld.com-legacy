---
title: Updating Ghostscript on CentOS 5.4 (ghostscript 8.70) (the remix)
layout: post
tags: linux
---
A while back I wrote an article on [updating to ghostscript 8.63 on CentOS 5.2](http://{{ site.url }}/updating-ghostscript-on-centos-52-ghostscript-863/). I received a fair amount of email and comments on the topic ranging from "thanks" to "you don't know what your talking about!" I thought I would update the original post to include the latest release of ghostscript (8.7) as well as answer and respond to the best question / statement in the comments... "how do you do that and can you post the SRPMS?" The answer is, yes, here is how I do it and "yes" I'll post the SRPMs (or more appropriately where I get them).

First, you have to have the latest version of the build environment as well as some prerequisites for building GhostScript:

{% highlight bash %}
yum --enablerepo remi groupinstall "Development Tools"
yum --enablerepo remi install libjpeg-devel libXt-devel libpng-devel gtk2-devel glib2-devel gnutls-devel libxml2-devel libtiff-devel cups-devel libtool jasper-devel
{% endhighlight %}

<small>(you will note here I use the [REMI repo](http://blog.famillecollet.com) )</small>

Next, I obtain the SRPM files from rpmfind.net and ghostscript-fonts from the centos repo:

{% highlight bash %}
wget ftp://195.220.108.108/linux/fedora/development/source/SRPMS/ghostscript-8.70-3.fc13.src.rpm
wget http://mirror.centos.org/centos/5.4/os/SRPMS/ghostscript-fonts-5.50-13.1.1.src.rpm
{% endhighlight %}

Now, I build them using RPM (rpmbuild):

{% highlight bash %}
rpmbuild --rebuild ghostscript-8.70-3.fc13.src.rpm
rpmbuild --rebuild ghostscript-8.70-1.fc10.src.rpm
{% endhighlight %}

and that is how I do it! If you are feeling exceptionally lazy and have some inherent trust for my builds in x86_64... here they are:

{% highlight bash %}
rpm -Uvh http://chrisschuld.com/centos54/ghostscript-8.70-1.x86_64.rpm http://chrisschuld.com/centos54/ghostscript-fonts-5.50-13.1.1.noarch.rpm http://chrisschuld.com/centos54/ghostscript-gtk-8.70-1.x86_64.rpm
{% endhighlight %}