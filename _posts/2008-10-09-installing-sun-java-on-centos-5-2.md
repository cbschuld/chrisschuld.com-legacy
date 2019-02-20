---
title: Installing Sun's Java on CentOS 5.2
layout: post
tags: centos
---

By far the most messy thing on CentOS 5.2 is adding Sun's Java.  I have never found great success from the different packages that are out there for installing java.  I prefer to simply use the packages from Sun.

<strong>Step (1)</strong>
Visit Sun's web site and download the latest version of Java &#40;the &#42;&#46;bin file not the  &#42;&#45;rpm&#46;bin&#41;
([http://java.sun.com/javase/downloads/index.jsp](http://java.sun.com/javase/downloads/index.jsp))
<em>pay close attention if you want the 32bit or 64bit version</em>



**Step (2)**
{% highlight bash %}
[user@www]# cd /opt/
[user@www]# wget "[GIANT_SUN_URL_TO_GET_THE_JAVA_BIN_FILE_x64_IN_THIS_CASE]"
[user@www]# /bin/sh jdk-6u7-linux-x64.bin
{% endhighlight %}

**Step (3)** Setup the alternatives correctly

{% highlight bash %}
[user@www]# alternatives --install /usr/bin/java java /opt/jdk1.6.0_07/bin/java 2
[user@www]# alternatives --config java
There are 2 programs which provide 'java'.
    Selection       Command
======================================================
*+ 1           /usr/lib/jvm/jre-1.4.2-gcj/bin/java
   2           /opt/jdk1.6.0_07/bin/java
   Enter to keep the current selection[+], or type selection number: 2
   [user@www]#
{% endhighlight %}

`Step (4)` Check to make sure the install was a success

{% highlight bash %}
[user@www]# java -version
java version "1.6.0_07"
Java(TM) SE Runtime Environment (build 1.6.0_07-b06)
Java HotSpot(TM) 64-Bit Server VM (build 10.0-b23, mixed mode)
[user@www]#
{% endhighlight %}