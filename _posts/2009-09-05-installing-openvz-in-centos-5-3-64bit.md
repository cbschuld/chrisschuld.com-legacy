---
title: Installing OpenVZ in CentOS 5.3 (64bit)
layout: post
tags: centos openvz
---
There are a few tutorials out there on installing OpenVZ in CentOS 5.3.  Here are the steps I use to install OpenVZ on a brand new installation of CentOS 5.3:

Note: this tutorial / walkthrough is for use 64 bit only

<ol>
<li>Update the box via yum</li>
<li>Install the OpenVZ Repository and grab the GPG key</li>
<li>Install OpenVZ</li>
<li>Install OpenVZ Controller and Quota system</li>
<li>Configure the local system for the OpenVZ kernel</li>
<li>Update OpenVZ's ARP Settings</li>
<li>Disable SELINUX</li>
<li>Reboot</li>
</ol>

{% highlight bash %}
yum -y update
cd /etc/yum.repos.d
wget http://download.openvz.org/openvz.repo
rpm --import http://download.openvz.org/RPM-GPG-Key-OpenVZ
yum -y install ovzkernel.x86_64
yum -y install vzctl.x86_64 vzquota.x86_64
{% endhighlight %}

Now; we need to configure the sysctl.conf file for OpenVZ
{% highlight bash %}
perl -pi -e 's/net\.ipv4\.ip_forward = 0/net\.ipv4\.ip_forward = 1/' /etc/sysctl.conf
perl -pi -e 's/kernel\.sysrq = 0/kernel\.sysrq = 1/' /etc/sysctl.conf
echo -e "\n\nnet.ipv4.conf.default.proxy_arp = 0\nnet.ipv4.conf.all.rp_filter = 1\nnet.ipv4.conf.default.send_redirects = 1\nnet.ipv4.conf.all.send_redirects = 0\nnet.ipv4.icmp_echo_ignore_broadcasts=1\nnet.ipv4.conf.default.forwarding=1\nkernel.ve_allow_kthreads=1\n" >> /etc/sysctl.conf
perl -pi -e 's/NEIGHBOUR_DEVS=detect/NEIGHBOUR_DEVS=all/' /etc/vz/vz.conf
{% endhighlight %}

Disable SELINUX
{% highlight bash %}
vi /etc/sysconfig/selinux
{% endhighlight %}

Reboot the machine
{% highlight bash %}
reboot
{% endhighlight %}