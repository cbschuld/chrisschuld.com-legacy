---
title: Backup an OpenVZ VPS
layout: post
tags: openvz
---

There are a lot of ways to backup an OpenVPS without powering them down.  I have two critical VPS systems both operating phone/PBX apps (asterisk) which I need to backup and I cannot get them to backup correctly while powered up (<em>driving me nuts</em>).  So weekly (early on Sunday mornings) I backup them up by quickly powering them off; backing them up and powering them back up.

<em>Side Note: Yes, yes, begin the hate mail: I power down the boxes; which creates all of the 65sec of down time.  If anyone is calling my office at 2AM on Sunday morning and can't leave a message please email me and I'll adjust our backup schedule!
</em>

The script also pushes the backup images to a mount at /nfs/backup <em>(a backup NAS system we have in place)</em>

Here is how I do it:

{% highlight bash %}
#!/bin/sh

if mount|grep -q ' nfs ' && df -T | grep -w nfs | grep -w "\/nas\/backup" | grep -q -wv "100%";then

        # date in YYYYMMDD format
        today=`date +%Y%m%0e`;

        echo -e "Stopping VZ 105"
        /usr/sbin/vzctl stop 105

        echo -e "Dumping VZ 105"
        /usr/bin/vzdump --suspend 105

        echo -e "Starting VZ 105"
        /usr/sbin/vzctl start 105

        echo -e "Compressing Output"
        /bin/gzip -9 /vz/dump/vzdump-105.tar

        echo -e "Backing up - moving file to NAS"
        /bin/mv /vz/dump/vzdump-105.tar.gz /nas/backup/__hostname__here__/vzdump-105-$today.tar.gz

else
        echo Error: the NFS mount for the backup NAS does not appear to be correct
fi
{% endhighlight %}