---
title: Updating Ghostscript on CentOS 5.2 &#40;ghostscript 8.63&#41;
layout: post
tags: linux centos
---

<strong>PLEASE NOTE: I have <a href="http://chrisschuld.com/2010/01/updating-ghostscript-on-centos-5-4-ghostscript-8-70/">posted an update for CentOS5.4 and GhostScript 8.70</a>!</strong>


Today I needed a newer version of ghostscript on my server pool for some back-end processing we do.  Updating ghostscript for RHEL5 / CentOS 5.2 turned out to be a pain!  I was nearly stucked into <a href="http://www.germane-software.com/~ser/Files/Essays/RPM_Hell.html">RPM hell</a>!

{% highlight bash %}
   **** Warning:  An error occurred while reading an XREF table.
   **** The file has been damaged.  This may have been caused
   **** by a problem while converting or transfering the file.
   **** Ghostscript will attempt to recover the data.
ERROR: /undefined in /BXlevel
Operand stack:
   7   0   1   --dict:6/6(ro)(G)--   obj
Execution stack:
   %interp_exit   .runexec2   --nostringval--   --nostringval--   --nostringval--   2   %stopped_push   --nostringval--   --nostringval--   --nostringval--   false   1   %stopped_push   1   3   %oparray_pop   1   3   %oparray_pop   1   3   %oparray_pop   --nostringval--   --nostringval--   --nostringval--   --nostringval--   --nostringval--   --nostringval--   false   1   %stopped_push   --nostringval--   %loop_continue   --nostringval--
Dictionary stack:
   --dict:1119/1686(ro)(G)--   --dict:0/20(G)--   --dict:107/200(L)--   --dict:107/200(L)--   --dict:104/127(ro)(G)--   --dict:241/347(ro)(G)--   --dict:18/24(L)--
Current allocation mode is local
ESP Ghostscript 815.02: Unrecoverable error, exit code 1
{% endhighlight %}

A few google-searches later I realized that ghostscript 8.15 is "<a href="http://www.imdb.com/title/tt0302886/">old school</a>" and needed a serious update.  I always like to have the latest software (generally speaking) so I was after the latest version to date (version 8.63) to hopefully solve some problems with PDF translation:


First, you'll need the jasper libraries which are not available via yum.  You can get them here <em>(i386 32bit only for now)</em>:

{% highlight bash %}

rpm -Uvh http://chrisschuld.com/centos52/jasper-libs-1.900.1-8.i386.rpm
rpm -Uvh http://chrisschuld.com/centos52/jasper-1.900.1-8.i386.rpm
rpm -Uvh http://chrisschuld.com/centos52/jasper-utils-1.900.1-8.i386.rpm
rpm -Uvh http://chrisschuld.com/centos52/jasper-devel-1.900.1-8.i386.rpm

{% endhighlight %}

Next, here are the RPMs for RHEL5/CentOS5.2 for Ghostscript <em>(i386 32bit only for now)</em>:

{% highlight bash %}

rpm -Uvh http://chrisschuld.com/centos52/ghostscript-8.63-1.i386.rpm
rpm -Uvh http://chrisschuld.com/centos52/ghostscript-devel-8.63-1.i386.rpm
rpm -Uvh http://chrisschuld.com/centos52/ghostscript-gtk-8.63-1.i386.rpm

{% endhighlight %}


<strong>*** Problem solved!</strong>



<strong>PLEASE NOTE: I have <a href="http://chrisschuld.com/2010/01/updating-ghostscript-on-centos-5-4-ghostscript-8-70/">posted an update for CentOS5.4 and GhostScript 8.70</a>!</strong>



