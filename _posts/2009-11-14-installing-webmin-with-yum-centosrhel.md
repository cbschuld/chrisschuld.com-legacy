---
title: Installing Webmin with YUM (CentOS,RHEL)
layout: post
tags: openvz
---
Here are the commands to install Webmin via Yum:

{% highlight bash %}
echo -e "[Webmin]\nname=Webmin Distribution Neutral\nbaseurl=http://download.webmin.com/download/yum\nenabled=1" > /etc/yum.repos.d/webmin.repo
rpm --import http://www.webmin.com/jcameron-key.asc
yum install webmin
{% endhighlight %}