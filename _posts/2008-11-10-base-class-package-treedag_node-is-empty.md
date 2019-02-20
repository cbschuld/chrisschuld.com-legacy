---
title: Base class package &quot;Tree&#58;&#58;DAG_Node&quot; is empty
layout: post
tags: linux perl
---

Today I ran into this error:

<strong>Base class package "Tree::DAG_Node" is empty.
    (Perhaps you need to 'use' the module which defines that package first.)
 at /usr/lib/perl5/vendor_perl/5.8.8/XML/Validator/Schema/Node.pm line 2
</strong>

An odd error from perl's XML Validation libraries; here is how you fix it: install the Tree::DAG_Node package

{% highlight bash%}
yum -y install perl-DAG_Node
{% endhighlight %}