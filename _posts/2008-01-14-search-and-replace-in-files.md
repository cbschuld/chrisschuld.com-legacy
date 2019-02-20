---
title: Search and Replace in Files
layout: post
tags: linux perl regex
---

Here is how to do a search and replace using Perl regex over a set of files:
<br/><br/>
{% highlight bash %}perl -pi -e 's/source/destination/g' *.ext{% endhighlight %}