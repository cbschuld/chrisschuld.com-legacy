---
title: Auto Mounting NFS Shares in /etc/fstab
layout: post
tags: linux
---

To mount an NFS share using fstab `(/etc/fstab)` you need to know a few things, the hostname or IP address of the NFS server, the share name and where you intend to mount the share at.  Next, add this line to the end of the /etc/fstab file:

{% highlight bash %}
[hostname_or_ip]:/[share_name]      /[your_mount_location]     nfs     rsize=8192,wsize=8192,timeo=14,intr
{% endhighlight %}

{% highlight bash %}
10.0.0.50:/backup     /nfs/backup     nfs     rsize=8192,wsize=8192,timeo=14,intr
{% endhighlight %}

When you are done, you can quickly refresh the `fstab` using the <a href="http://chrisschuld.com/2007/08/reload-fstab-etcfstab/">mount command</a>