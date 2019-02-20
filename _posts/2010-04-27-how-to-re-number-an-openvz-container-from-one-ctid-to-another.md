---
title: How to Re-number an OpenVZ Container from one CTID to another
layout: post
tags: linux centos
---

Poor planning: I guess I am guilty. A few times I have needed to re-number an OpenVZ Container. You just need to know what your current CTID is (sourcecid) and your desired target CTID (targetcid).
<!--more-->

Here are the steps:

{% highlight bash %}
sourcecid=100
targetcid=101
vzctl chkpnt ${sourcecid} --dumpfile /tmp/openvz-renumber-dump.${sourcecid}
mv /etc/vz/conf/${sourcecid}.conf /etc/vz/conf/${targetcid}.conf
mv /vz/private/${sourcecid} /vz/private/${targetcid}
mv /vz/root/${sourcecid} /vz/root/${targetcid}
vzctl restore ${targetcid} --dumpfile /tmp/openvz-renumber-dump.${sourcecid}
{% endhighlight %}