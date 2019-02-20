---
title: Installing vzdump for OpenVZ on CentOS
layout: post
tags: openvz
---
There are a few items required for installing <a href="http://wiki.openvz.org/Backup_of_a_running_container_with_vzdump">vzdump</a> for <a href="http://wiki.openvz.org/Main_Page">OpenVZ</a> on CentOS.

First, you'll need an MTA - I suggest making sure you have postfix installed; if you have postfix installed the initial RPM requirement for "MTA" will be handled for you.  Next, you'll need <a href="http://www.cons.org/cracauer/cstream.html">cstream</a>.  This installation is slightly more tricky because (as far as I know) there is no real way to gain this from yum unless you use the <a href="http://dag.wieers.com/rpm/">DAG Wieers</a> repo.  Also, depending on what you have already installed you will likely need the Simple Locking file I/O library for Perl.

Here is how you get vzdump on a clean version of CentOS (via the hostnode):


{% highlight bash %}

rpm -ivh "ftp://ftp.pbone.net/mirror/ftp.freshrpms.net/pub/freshrpms/pub/dag/redhat/el5/en/x86_64/RPMS.dag/cstream-2.7.4-3.el5.rf.x86_64.rpm"
wget http://dag.wieers.com/rpm/packages/perl-LockFile-Simple/perl-LockFile-Simple-0.206-1.el5.rf.noarch.rpm
rpm -ivh perl-LockFile-Simple-0.206-1.el5.rf.noarch.rpm
/bin/rm perl-LockFile-Simple-0.206-1.el5.rf.noarch.rpm
rpm -ivh "http://chrisschuld.com/centos54/vzdump-1.2-6.noarch.rpm"

{% endhighlight %}


Since version 1.2-6 of vzdump the location of the modules is not "automatic" and have found it necessary to export the location of the PVE libraries that vzdump requires via this command:

{% highlight bash %}
export PERL5LIB=/usr/share/perl5/
{% endhighlight %}

All said and done there has to be a better way to do this... anyone... anyone??



<em><strong>NOTE</strong>: 7/19/2010 - Proxmox updated their site... I updated all of the links!</em>