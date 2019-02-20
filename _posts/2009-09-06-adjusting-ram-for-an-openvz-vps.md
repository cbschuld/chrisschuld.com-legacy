---
title: Adjusting RAM for an OpenVZ VPS
layout: post
tags: openvz
---

Here are commands to help adjust the memory / RAM for an OpenVZ VPS:

<strong>64MB Guaranteed, 128MB Burstable</strong>

{% highlight bash %}
cid=1000
vzctl set ${cid} --vmguarpages 64M --save
vzctl set ${cid} --oomguarpages 64M --save
vzctl set ${cid} --privvmpages 64M:128M --save
{% endhighlight %}

<strong>256MB Guaranteed, 512MB Burstable</strong>

{% highlight bash %}

cid=1000
vzctl set ${cid} --vmguarpages 256M --save
vzctl set ${cid} --oomguarpages 256M --save
vzctl set ${cid} --privvmpages 256M:512M --save
{% endhighlight %}

<strong>512MB Guaranteed, 1024MB Burstable</strong>

{% highlight bash %}
cid=1000
vzctl set ${cid} --vmguarpages 512M --save
vzctl set ${cid} --oomguarpages 512M --save
vzctl set ${cid} --privvmpages 512M:1024M --save
{% endhighlight %}

<strong>1024MB Guaranteed, 2048MB Burstable</strong>

{% highlight bash %}
cid=1000
vzctl set ${cid} --vmguarpages 1024M --save
vzctl set ${cid} --oomguarpages 1024M --save
vzctl set ${cid} --privvmpages 1024M:2048M --save
{% endhighlight %}