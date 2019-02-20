---
title: How to fix the Curl Error&#58; error setting certificate verify locations
layout: post
tags: centos
---

Today I had a new server running CentOS5 have trouble with a known good authorize.net library using curl.  It was producing the following error&#58;

{% highlight bash %}
error setting certificate verify locations: CAfile: /etc/pki/tls/certs/ca-bundle.crt CApath: none
{% endhighlight %}

After some research I found it was based on the inability for the apache user to access the ca-bundle.crt file.  You will find solutions on the web suggesting adding <em>curl_setopt($link, CURLOPT_SSL_VERIFYPEER, FALSE);</em> to your script to disable the peer verification -- I suggest you <strong>not</strong> do this and simply fix the permissions for your CA file.

Execute this&#58;
{% highlight bash %}
/bin/chmod 755 /etc/pki/tls/certs
{% endhighlight %}

Solved!