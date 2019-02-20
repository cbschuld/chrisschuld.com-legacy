---
title: Cellpadding and Cellspacing in CSS (part 2)
layout: post
tags: css xhtml
---

Here is a follow up to the <a href="http://chrisschuld.com/2008/04/cellpadding-and-cellspacing-in-css/">cellpadding and cellspacing post</a> I made a while back.  The cellpadding and cellspacing can be completely controlled in CSS.  I realized today. I spoke only about collapsing the borders and not creating spacing `or the equivalent of cellspacing equal to something other than 0`.


Here are some HTML4 and CSS/XHTML equivalents&#58;


<strong>HTML4 :</strong>
{% highlight html %}
<table cellspacing="0" cellpadding="0">
{% endhighlight %}

<strong> CSS :</strong>
{% highlight css %}
table { border-collapse: collapse; }
table tr td { padding: 0px; }
{% endhighlight %}


<strong>HTML4 :</strong>
{% highlight html %}
<table cellspacing="2" cellpadding="0">
{% endhighlight %}

<strong> CSS :</strong>

{% highlight css %}
table { border-collapse: separate; border-spacing: 2px; }
table tr td { padding: 0px; }
{% endhighlight %}


<strong>HTML4 :</strong>

{% highlight html %}
<table cellspacing="2" cellpadding="2">
{% endhighlight %}

<strong> CSS:</strong>

{% highlight css %}
table { border-collapse: separate; border-spacing: 2px; }
table tr td { padding: 2px; }
{% endhighlight %}


You may want to place these definitions into a CSS class so you can quickly reference your table definition in XHTML&#58;


**CSS:**

{% highlight css %}
table.info { border: 1px solid #ccc; border-collapse: separate; border-spacing: 2px; }
table.info tr th { font-weight: normal; text-align: right; }
table.info tr td { font-weight: bold; padding: 2px; }
{% endhighlight %}


**HTML:**

{% highlight html %}
<table class="info">
  <tr><th>First Name:</th><td>Chris</td></tr>
  <tr><th>Last Name:</th><td>Schuld</td></tr>
</table>
{% endhighlight %}

Here is what it will look like:
{% highlight html %}
<table style="border: 1px solid #ccc; border-collapse: separate; border-spacing: 2px;" border="0">
<tbody>
<tr>
<th style="font-weight: normal;text-align: right;">First Name:</th>
<td style="font-weight: bold; padding: 2px;">Chris</td>
</tr>
<tr>
<th style="font-weight: normal;text-align: right;">Last Name:</th>
<td style="font-weight: bold; padding: 2px;">Schuld</td>
</tr>
</tbody></table>
{% endhighlight %}