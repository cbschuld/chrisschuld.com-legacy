---
title: Playing MP3 Files in Fedora 8 using Gnome
layout: post
tags: linux fedora
---

To play MP3 files in Fedora 8 you need to add software to your default installation:

<li>First, add Livna sources using <strong>rpm</strong>
{% highlight bash %}rpm -ivh http://rpm.livna.org/livna-release-8.rpm{% endhighlight %}
</li>
<li>Next, Install Rhythmbox (assuming you are using Gnome) using <strong>yum</strong>
{% highlight bash %}yum install rhythmbox{% endhighlight %}
</li>
<li>Next, Install gstreamer-plugins-ugly<sup>**</sup> using <strong>yum</strong>
{% highlight bash %}yum install gstreamer-plugins-ugly{% endhighlight %}
</li>
That is it, next launch Rythmbox and hello music!
<img src='http://chrisschuld.com/wp-content/uploads/2007/08/fedora-rythmbox-launch.png' alt='Rythmbox Launch' />

<em>Q: Hey Chris, why does the gstreamer-plugins end in "-ugly"
A: Good question, tough answer, the GStreamer is a streaming media library which contains plug-ins which cannot be shipped in gstreamer-plugins-good because the license is <strong>not</strong> LGPL.  Please note the the license of the entire library is <strong>not</strong> LGPL!  So of course you shouldn't install it unless you pay the owners for licensing rights.
</em>