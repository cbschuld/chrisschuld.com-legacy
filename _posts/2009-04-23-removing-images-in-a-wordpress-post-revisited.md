---
title: Removing Images in a WordPress Post (Revisited)
layout: post
tags: wordpress php
---

A while back I wrote a semi-popular post on <a href="http://chrisschuld.com/2008/08/removing-images-from-a-wordpress-post/">removing images from a WordPress post</a> -- today I am revisiting it.  The original solution used <a href="http://codex.wordpress.org/Template_Tags/the_content">the_content()</a> and the <a href="http://us2.php.net/outcontrol">output buffer</a> to remove the images out of the post.  Now that I have used <a href="http://wordpress.org/">WordPress</a> a bit longer and candidly had to use the solution again and thought "<em>what was I thinking</em>" I thought I would share the cleaner solution:

{% highlight php %}
<?php echo preg_replace('/&lt;img[^&gt;]+./','',get_the_content()); ?>
{% endhighlight %}