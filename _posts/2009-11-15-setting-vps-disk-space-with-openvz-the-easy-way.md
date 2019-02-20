---
title: Setting VPS Disk Space with OpenVZ the &quot;easy way&quot;
layout: post
tags: openvz
---
Disk space can be easily controlled via OpenVZ but I have yet to find anyone to actually explain what the heck to "really" do when you need to add more! Everything I have found about OpenVZ just explains the parameters and never shows you how to do it easily. When I need to adjust disk space on an VPS it is usually when I have someone beating up my ear on the phone or my IM so I needed a fast way to expand the disk without worrying about the details.
There are three parameters in OpenVZ which are directly related to disk usage. They are <strong>disk_quota</strong>, <strong>diskspace</strong> and <strong>diskinodes</strong>. <em><strong>NOTE</strong>: there are a lot of other parameters that control and effect the disk but this tutorial will only cover the basics!</em>
The parameter <strong>disk_quota</strong> is a YES or NO value which disables the file system quotas; if you are not worried about the quotas set it to NO and stop reading. Otherwise; leave it set at YES and continue.
The parameter <strong>diskspace</strong> is the count of 1K blocks available to the VPS in a soft and hard limit. The hard limit is a stop point similar to filling up a physical disk - when you are out, you are out. The soft limit is when the bean counters get angry and the quotatime timer starts. On a basic installation and VPS setup you will have a 1048576 1K blocks as a soft limit and 1153024 1K blocks as a hard limit. The numbers are not <em>crazy</em> as they are derived from [base2](http://en.wikipedia.org/wiki/Binary_numeral_system). Thus, 1048576 1K blocks is 1GB of disk space. Add an additional 10.2MB to the disk space and you arrive at the 1048576 1K blocks. These are the basic numbers for the basic template that ships with OpenVZ.
The parameter <strong>diskinodes</strong> is the total number of files, directories and links you can have in the container. Think of them as <a href="http://en.wikipedia.org/wiki/Post-it_note">Post-it notes</a> and each file, directory and link gets a single note. The default basic number is 200,000 for a soft limit for 1GB of disk space and 220,000 for the hard limit. Normally `*nix` systems will set aside enough inodes for one inode per 4K disk space block. In the default template for OpenVZ they are setting aside enough inodes for 5.2K blocks. Which I'll write off as either (a) a magic number or (b) a unique calculation I am not familiar with. Thus, because the 4K block inode count for 1GB of disk space should be 262,144 inodes we\'ll use the default template values for our calculations and simply multiply times the number of GB requested.

So.. now...

The question is how do you adjust them quickly and easily. In this example we are going to work with units of GBs. If you need more granularity you will need to divide it back out to MBs but Gigabytes works great for our needs:

First, we need to define the soft and hard limits, next we apply the updated diskspace numbers and finally set the inode numbers correctly based on the ratio we know from the default template:

Here are the commands (<em>and note below for a quick and easy Perl script</em>):
{% highlight bash %}
cid=1324
gb=5
vzctl set ${cid} --diskspace $((1048576 * ${gb})):$((1153434 * ${gb})) --save
vzctl set ${cid} --diskinodes $((200000 * ${gb})):$((220000 * ${gb})) --save
{% endhighlight %}

{% highlight perl %}
#!/usr/bin/perl

# display the commands to update an OpenVZ VPS with new disk space requirements
# 2009/11/15 - Chris Schuld (chris@chrisschuld.com)

use strict;

print "Enter VPS CID: "; my $_CID = ; chomp($_CID);
print "Enter SOFT Diskspace Limit (ex 10GB):"; my $_SOFT = ; chomp($_SOFT); $_SOFT =~ s/[^0-9]//g;
print "Enter HARD Diskspace Limit (ex 11GB):"; my $_HARD = ; chomp($_HARD); $_HARD =~ s/[^0-9]//g;
my $_INODE_SOFT = ( 200000 * $_SOFT );
my $_INODE_HARD = ( 220000 * $_HARD );
print "Run these commands:\n";
print "vzctl set $_CID --diskspace ".$_SOFT."G:".$_HARD."G --save\n";
print "vzctl set $_CID --diskinodes $_INODE_SOFT:$_INODE_HARD --save\n";
{% endhighlight %}