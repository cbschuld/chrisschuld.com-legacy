---
title: Extracting Smarty variables from source
layout: post
tags: smarty
---

You can extract all of the variables in use from a Smarty template using a simple call to `*nix` grep with a trivial regex expression. Here is the command-

{% highlight bash %}
grep -o "\{\$[-_a-zA-Z0-9]*\}" my-template.tpl
{% endhighlight %}