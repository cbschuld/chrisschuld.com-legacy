---
title: Setting Environment Variables in Perl
layout: post
tags: perl
---

If you ever have to set an environment variable you may run into the same reality I ran into.

A simple call to system using export (as you might do on the command line)...

<pre lang="perl">system( "export MYVAR=somevalue" );</pre>

...does not work!

You have to use the Perl ENV hash variable&#58;

<pre lang="perl">$ENV{'MYVAR'} = "somevalue";</pre>

Changes to $ENV{'SOMEVAR'} will be available to the current process and children processes only.  Thus, if you  change an environment variable for an upcoming system() call the process started due to the system() call will see the environment variable change.

Here is an example&#58;

{% highlight perl %}
$ENV{'http_proxy'} = "192.168.0.10";
system( "wget --tries=2 --timeout=8 $url" );
{% endhighlight %}
