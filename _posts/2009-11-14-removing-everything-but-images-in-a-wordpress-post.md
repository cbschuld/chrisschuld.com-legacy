---
title: Removing everything BUT Images in a WordPress Post
layout: post
tags: wordpress
---
A while back I wrote an article on <a href="http://chrisschuld.com/2008/08/removing-images-from-a-wordpress-post/">Removing Images from a WordPress</a> Post.  Sebastian asked an interesting question; he wanted to remove everything but the images.  This is actually pretty straightforward; here is how you do it:
{% highlight php %}
        <?php
           $beforeEachImage = "<div>";
           $afterEachImage = "</div>";
           preg_match_all("/(<img [^>]*>)/",get_the_content(),$matches,PREG_PATTERN_ORDER);
           for( $i=0; isset($matches[1]) && $i < count($matches[1]); $i++ ) {
                 echo $beforeEachImage . $matches[1][$i] . $afterEachImage;
           }
        ?>
{% endhighlight %}

Keep in mind this code needs to be in the <a href="http://codex.wordpress.org/The_Loop">WordPress Loop</a> and you can control what is around each image using the variables <strong>beforeEachImage</strong> and <strong>afterEachImage</strong> above.
