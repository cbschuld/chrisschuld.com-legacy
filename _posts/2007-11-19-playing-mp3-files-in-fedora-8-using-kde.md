---
title: Playing MP3 Files in Fedora 8 using KDE
layout: post
tags: linux fedora
---

To play MP3 files in Fedora 8 with KDE you need to add software to your default installation.  This software does not come "stock" with KDE because the software is not free and RedHat is required to <em>filter it</em> -- therefore if you download this update make sure you check the licensing agreements&#58;
<li>First&#44; add Livna sources using **rpm***</li>
{% highlight bash %}
rpm -ivh http://rpm.livna.org/livna-release-8.rpm
{% endhighlight %}

<li>Next&#44; Install kdemultimedia-extras-nonfree<sup>**</sup> using **yum**</li>
{% highlight bash %}yum install kdemultimedia-extras-nonfree{% endhighlight %}
That is it&#44; next launch Amarok as an example and hello MP3 music&#33;
<img src='http://chrisschuld.com/wp-content/uploads/2007/11/screenshot-kde-amarok.png' alt='Amarok Launching' />
<em>Q&#58; Hey Chris, why does the kdemultimedia-extras package end in "-nonfree"
A: Good question, tough answer, the kdemultimedia-extras-nonfree package contains plug-ins which cannot be shipped by Red Hat / Fedora because the license is <strong>not</strong> LGPL.  Please note the the license of the entire library is <strong>not</strong> LGPL!  So of course you shouldn't install it unless you pay the owners for licensing rights.
</em>