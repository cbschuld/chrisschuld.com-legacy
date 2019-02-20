---
title: Moving a WordPress Install from one Domain (A) to another Domain (B)
layout: post
tags: wordpress
---

From time to time I had have to move one installation of WordPress from one domain (<em>let's call it domain A</em>) to a new domain (<em>let's call it domain B</em>).  Because WordPress embeds the domain all over the data schema (not faulting; simply disclosing) you have to make a lot of dB changes for the updated site location to function.  Here is the quick and dirty way to move the data:

{% highlight sql %}
UPDATE wp_posts SET post_content = REPLACE(post_content,"[OLD_DOMAIN]","[NEW_DOMAIN]");
UPDATE wp_posts SET guid = REPLACE(guid,"[OLD_DOMAIN]","[NEW_DOMAIN]");
UPDATE wp_options SET option_value = REPLACE(option_value,"[OLD_DOMAIN]","[NEW_DOMAIN]");
UPDATE wp_postmeta SET meta_value = REPLACE(meta_value,"[OLD_DOMAIN]","[NEW_DOMAIN]");
{% endhighlight %}

Finally, for the final bit of trickery if you are using <a href="http://wordpress.org/extend/plugins/wp-super-cache/">Advanced Caching</a> on the site there is a great place where the localized PATH is hard coded.  Edit your new and updated path on file <strong>advanced-cache.php</strong>

{% highlight bash %}
vi wp-content/advanced-cache.php
{% endhighlight %}
