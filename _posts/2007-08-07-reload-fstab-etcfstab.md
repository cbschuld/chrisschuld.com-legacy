---
title: Reload fstab (/etc/fstab)
layout: post
tags: linux fedora
---

If you make a new entry in fstab it will not auto-mount.  Therefore you must reload / refresh the entries.  A reboot will do this but that is not a friendly way to do it.  A quick way to reload new entries in /etc/fstab (fstab) is to use the mount command:
{% highlight bash %}
mount -a
{% endhighlight %}

<img class="block" src='/public/images/mount-a-example.png' alt='Mount -a' />
