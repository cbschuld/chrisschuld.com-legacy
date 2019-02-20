---
title: jquery.suggest 1.2
layout: post
tags: php
---

A few people have contacted in the past about what I did to get IDs to work on Peter’s Script over at <a href="http://vulgarisoips.com">vulgarisoips.com</a> (<a href="http://www.vulgarisoip.com/2007/08/06/jquerysuggest-11/">see the original post here</a>).

Peter’s script works great; but for my needs I had to add an ID to the suggestion as a way to relate the selected value back to a dB entry.

First, I needed a way to tell the script where to add the results to in the DOM instead of having the script add the object automatically.  I created a new option called <strong>attachObject </strong>which allowed me to control the object in the DOM.  This allowed me to do this:

<pre lang="php">$('#name').suggest('/suggest/client',{dataContainer:'#cid', attachObject:'#sresults', onSelect: myFunction );</pre>

Note how above I use <strong>#sresults</strong> as my object to attach the suggestion results to.  In my edits if you leave out the <strong>attachObject </strong>it will still build the &lt;ul&gt; object for you without any issues.

Next, I needed a way to have the ID go along with the representation values (ex. a hash-like key, value relationship).  To do this I added two other options to the script: one called <strong>dataContainer </strong>and one called dataDelimiter which I set to a default value of tab (\t).  The <strong>dataContainer </strong>is an ID of an input box which holds the database ID of the selected object in the suggest box.  The <strong>dataDelimiter </strong>is the delimiter for the payload which contains the key values pairs separated by the <strong>dataDelimiter</strong>.  (Note: the "row" delimiter is still a new line character).

In my XHTML I have this:

{% highlight html %}
<input type="hidden" name="cid" id="cid" value="-1"/>
<input type="text" id="name" size="30" maxlength="128"/>
<div id="suggestResults"></div>
{% endhighlight %}

(and I use the script stub above...)

On the server I have /suggest/client do something similar to this:

{% highlight php %}
$stmt->execute();
foreach( $stmt->fetchAll(PDO::FETCH_OBJ) as $row ) {
echo "{$row->displayName}\t{$row->tmpid}\n";
}
{% endhighlight %}

<strong>NOTE:</strong> I do make an assumption your keys will always be unique; as I append a <strong>s_</strong> to the key to construct the necessary &lt;li&gt; items (need to keep them unique for DOM reasons).

Here is the original version of Peter's script: <a href="http://chrisschuld.com/wp-content/uploads/2008/07/suggestoriginal.txt">Original Version 1.1 (in text)</a>

Here are my updates (let us call it v1.2):<a href="http://chrisschuld.com/wp-content/uploads/2008/07/suggestupdated.txt">Updated Version 1.2 (in text)</a>

<em>In hindsight there are definitely better ways to do this but this solution is working great still (this idea and solution go back to August of 2007); and I will always suggest "working effectively in production" is always better than how it "should be."</em>