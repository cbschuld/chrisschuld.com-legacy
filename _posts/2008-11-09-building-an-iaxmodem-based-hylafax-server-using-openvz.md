---
title: Building an IAXModem-based HylaFax&#43; server using OpenVZ
layout: post
tags: linux centos openvz
---

If you happen to have a Asterisk solution for voice on your network occasionally it is nice to be able to send faxes from your network without the need of a PSTN line at your endpoint.  At my company we do this by running a fax server on an OpenVZ VPS on the same subnet as our Asterisk PBX.  Here is how we build our fax server:

First, we build the OpenVZ VPS with CentOS and add the /dev/ptmx device (your VPS will likely already have this on it):

{% highlight bash %}
vzctl create 1057 --ostemplate centos-5-i386-default --config vps.basic
vzctl set 1057 --hostname fax.aztecsoftware.net --save
vzctl set 1057 --ipadd 10.0.0.57 --save
vzctl set 1057 --nameserver 10.0.0.15 --save
mknod --mode 666 /vz/private/1057/dev/ptmx c 5 2

{% endhighlight %}
<em>(Note: there is a good chance the 98 UNIX device /dev/ptmx is going to already be there from your template -- you can disregard any errors you get during the "forced" creation of that device)</em>

Next, we start the VPS and enter the VE by running the following:

{% highlight bash %}
vzctl start 1057
vzctl enter 1057
{% endhighlight %}

Next, we start the update and install process via yum and a few RPMs I built for <a href="http://chrisschuld.com/2008/11/updating-ghostscript-on-centos-52-ghostscript-863/">Ghostscript</a>:
{% highlight bash %}
yum -y update
yum -y install rpm-build make libtiff-devel zlib-devel gcc gcc-c++ pam-devel openldap-devel freeglut libjpeg-devel libICE libSM libXt cairo urw-fonts

rpm -Uvh http://chrisschuld.com/centos52/jasper-libs-1.900.1-8.i386.rpm
rpm -Uvh http://chrisschuld.com/centos52/jasper-1.900.1-8.i386.rpm
rpm -Uvh http://chrisschuld.com/centos52/jasper-utils-1.900.1-8.i386.rpm
rpm -Uvh http://chrisschuld.com/centos52/jasper-devel-1.900.1-8.i386.rpm
rpm -Uvh http://chrisschuld.com/centos52/ghostscript-fonts-8.11-1ht.noarch.rpm
rpm -Uvh http://chrisschuld.com/centos52/ghostscript-8.63-1.i386.rpm
rpm -Uvh http://chrisschuld.com/centos52/ghostscript-devel-8.63-1.i386.rpm

cd /root
wget http://internap.dl.sourceforge.net/sourceforge/hylafax/hylafax-5.2.7-1.src.rpm
wget http://internap.dl.sourceforge.net/sourceforge/hylafax/hylafax.spec

rpm -i hylafax-5.2.7-1.src.rpm
rpmbuild -bb hylafax.spec
rpm -i /usr/src/redhat/RPMS/i386/hylafax-5.2.7-1.i386.rpm
chkconfig --levels 345 hylafax on

{% endhighlight %}

Now, because we are on Asterisk we'll use an IAXModem for our communication device; if you do have access to a "real" PSTN by all means use a fax-capable modem and don't use the IAXModem because it is not a good 100% solution.  However, here is our IAXModem method:

{% highlight bash %}
cd /root
wget http://voxel.dl.sourceforge.net/sourceforge/iaxmodem/iaxmodem-1.1.1.tar.gz
tar xzvf iaxmodem-1.1.1.tar.gz
cd iaxmodem-1.1.1
./configure
make
cp iaxmodem /usr/local/sbin/
mkdir /etc/iaxmodem /var/log/iaxmodem
touch /var/log/iaxmodem/iaxmodem
pushd .; cd /etc/iaxmodem
wget http://chrisschuld.com/wp-content/uploads/2008/11/ttyIAX0
popd
pushd .; cd /etc/init.d/
wget http://chrisschuld.com/wp-content/uploads/2008/11/iaxmodem
popd
cp config.ttyIAX /var/spool/hylafax/etc/config.ttyIAX0

### Add our local configuration differences
vi /etc/iaxmodem/ttyIAX0

### Add our local configuration differences
vi /var/spool/hylafax/etc/config.ttyIAX0

chmod +x /etc/init.d/iaxmodem
chkconfig --add iaxmodem
/usr/local/sbin/iaxmodem
echo "iax0:2345:respawn:/usr/sbin/faxgetty ttyIAX0" >> /etc/inittab

{% endhighlight %}

Now, we REBOOT to make sure everything comes up:
{% highlight bash %}
reboot
{% endhighlight %}

After the VE re-appears we run our fax setup program:

{% highlight bash %}
faxsetup
{% endhighlight %}

That should do 90% of the work for you -- no you just have to configure the server for your needs!

