---
title: Playing MP3 files in Fedora 7
layout: post
tags: fedora
---

To play MP3 files in Fedora 7 you need to add software to your default installation:
<li>First, add Livna sources using <strong>rpm</strong></li>
<pre lang="bash">rpm -ivh http://rpm.livna.org/livna-release-6.rpm</pre>

<li>Next, Install Rhythmbox using <strong>yum</strong></li>
<pre lang="bash">yum install rhythmbox</pre>

<li>Next, Install gstreamer-plugins-ugly<sup>**</sup> using <strong>yum</strong></li>
{% highlight bash %}yum install gstreamer-plugins-ugly{% endhighlight %}

That is it, next launch Rythmbox and hello music!
<img src='http://chrisschuld.com/wp-content/uploads/2007/08/fedora-rythmbox-launch.png' alt='Rythmbox Launch' />

<em>Q&#58; Hey Chris, why does the gstreamer-plugins end in "-ugly"
A&#58; Good question, tough answer, the GStreamer is a streaming media library which contains plug-ins which cannot be shipped in gstreamer-plugins-good because the license is <strong>not</strong> LGPL.  Please note the the license of the entire library is <strong>not</strong> LGPL!  So of course you shouldn't install it unless you pay the owners for licensing rights.
</em>