---
title: Email Address Parsing
layout: post
tags: linux regex
---

Parsing out email addresses is a tedious task.  This task  hits my desk on a consistent basis.  Usually, in my case, the list is coming out of Outlook.  If the target list is coming out of Outlook make sure you export using Tab Separated for DOS (thus, click on File&#45;&#45;&#62;Import/Export-->Export to a File&#45;&#45;&#62;Tab Separated (DOS)&#45;&#45;&#62;&#91;select_the_target_folder&#91;).  Take this target file and execute this command&#58;

{% highlight bash %}
cat [filename] | grep -o -P "[[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(local|aero|coop|info|museum|name|([0-9]{ 1,3})|([a-zA-Z]{2,3}))]*"
{% endhighlight %}

Alternatively I usually need a list of unique addresses&#58;

{% highlight bash %}
cat [filename] | grep -o -P "[[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(local|aero|coop|info|museum|name|([0-9]{ 1,3})|([a-zA-Z]{2,3}))]*" | sort -u
{% endhighlight %}

