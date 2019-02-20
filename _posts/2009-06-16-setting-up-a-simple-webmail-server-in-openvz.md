---
title: Setting up a simple Web/Mail Server in OpenVZ
layout: post
tags: php
---

Here are the steps I continue to use over and over to build utilities/project servers in OpenVZ.  Utilities servers host web apps, mailing applications, etc for my company.  We usually build them as self-contained little appliance-like servers.  My vision and goal is <strong>simple == better</strong> every day!

First, we create the virtual machine:
{% highlight bash %}
cid=1164
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

Now that we are in the virtual machine and away from the HN we add the REMI repo and apply the updates directly on the box.

{% highlight bash %}
wget http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-3.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-5.rpm
rpm -Uvh remi-release-5*.rpm epel-release-5*.rpm
/bin/rm epel-release-5-3.noarch.rpm remi-release-5.rpm

yum --enablerepo remi -y update
yum --enablerepo remi -y install httpd php php-devel php-pear php-gd php-xsl php-mbstring php-mcrypt php-mysql mysql
{% endhighlight %}

Add Postfix and switch it on via <strong>system-switch-mail</strong>
{% highlight bash %}
yum --enablerepo remi -y install postfix system-switch-mail
system-switch-mail
{% endhighlight %}

Now... customer configurations and setups...