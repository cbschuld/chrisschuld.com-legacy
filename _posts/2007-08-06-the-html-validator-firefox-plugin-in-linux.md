---
title: The HTML Validator Firefox Plugin In Linux
layout: post
tags: fedora firefox
---

I use the "<a href="http://users.skynet.be/mgueury/mozilla/">HTML Validator</a>" Firefox plugin daily.  I found it does not work out of the box in Linux namely <a href="http://fedoraproject.org/">Fedora Core 6</a> and <a href="http://fedoraproject.org/">Fedora 7</a>.  You immediately get a HTML-rendered screen that states&#58;
<div class="ref"><pre>FATAL ERROR &#58; The dynamic C library contained in the extension file could not be found</pre></div>

Getting rid of this message took me a few minutes of research and I never found a step-by-step HOW-TO for Fedora -- so here goes!

Here is how you get rid of this message and get the plugin working in <a href="http://fedoraproject.org/">Fedora Core 6</a> or <a href="http://fedoraproject.org/">Fedora 7</a>&#58;

- First, uninstall the plugin by clicking on `Tools`&#45;&#45;&#62;Add-ons and clicking uninstall
<a href='http://chrisschuld.com/wp-content/uploads/2007/08/remove-firefox-addon.png' title='Remove HTML Validator'><img src='http://chrisschuld.com/wp-content/uploads/2007/08/remove-firefox-addon.png' alt='Remove HTML Validator' /></a>
- Second, close all instances of Firefox
- Next, install three packages using yum
`compat-libstdc++-296` `compat-libstdc++-33` `tidy`

{% highlight bash %}yum install compat-libstdc++-296 compat-libstdc++-33 tidy{% endhighlight %}
- Reinstall the <a href="http://users.skynet.be/mgueury/mozilla/">HTML Validator</a> plugin
- Restart Firefox, done!
<a href="http://users.skynet.be/mgueury/mozilla/">HTML Validator</a> should now be installed inside of Firefox on <a href="http://fedoraproject.org/">Fedora Core 6</a> or <a href="http://fedoraproject.org/">Fedora 7</a>
