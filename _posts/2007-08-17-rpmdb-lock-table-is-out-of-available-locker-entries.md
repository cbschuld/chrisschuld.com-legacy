---
title: rpmdb&#58; Lock table is out of available locker entries
layout: post
tags: linux fedora
---

If while using 'yum' or 'rpm' you receive the following error:
<pre lang="bash">rpmdb: Lock table is out of available locker entries</pre>

Your RPM dB files are screwed up... here is how you unscrew them!

<em>This error tell you the Berkley database files which RPM uses are damaged and in order to clear the error you must rebuild the Berkley dB files from scratch.</em>

Here is how you fix this error&#58;
<ol>
<li>Make a backup of  your current files</li>
<li>Remove the damaged files</li>
<li>Rebuild your RPM Berkley dB files</li>
<li>Use yum again</li></ol>

Here is the command walk through&#58;
<ol>
<li>As root, execute this:<br/><pre lang="bash">cd /root; tar cvzf rpm-backup.tar.gz /var/lib/rpm</pre></li>
<li>Remove the Berkeley dB files which yum and rpm use:<br/><pre lang="bash">rm /var/lib/rpm/__db.00*</pre></li>
<li>Instruct rpm to rebuild the databases files:<br/>{% highlight bash %}rpm --rebuilddb{% endhighlight %}</li>
<li>Test your yum command again:<br/><pre lang="bash">yum install somepackage</pre></li>
</ol>


