---
title: Installing PBX in a Flash (PIAF) on an OpenVZ VPS
layout: post
tags: linux centos openvz asterisk
---

After digging through the Internet looking for a solution to install <a href="http://pbxinaflash.net/">PBX in a Flash</a> on an <a href="http://wiki.openvz.org">OpenVZ</a> VPS and coming out empty handed I decided to dissect the installation myself and I came up with the following method for installing the PBX system on an OpenVZ VPS.  Now, that being said I could not find another "working" solution so this may not be the "best" method but it is repeatable and does work.  I have a PBX running off this installation currently.

In this example I am going to assume the VPS is VEID 1024 whose IP address will be 10&#46;0&#46;0&#46;24, running on a 10&#46;0&#46;0&#46;0&#47;24 network NAT'ed behind a router with a name server located at 10&#46;0&#46;0&#46;10&#46;

I am also going to assume you have <a href="http://wiki.openvz.org">OpenVZ</a> installed, if you don't visit here: <a href="http://www.howtoforge.com/installing-and-using-openvz-on-centos5.2">http://www.howtoforge.com/installing-and-using-openvz-on-centos5.2</a>

First, you have to create the OpenVZ VPS container using a CentOS 5 template&#58;

{% highlight bash %}
cd /vz/template/cache
wget http://download.openvz.org/template/precreated/contrib/centos-5-i386-default.tar.gz
vzctl create 1024 --ostemplate centos-5-i386-default --config vps.basic
vzctl set 1024 --onboot yes --save
vzctl set 1024 --hostname pbx.mycompany.net --save
vzctl set 1024 --ipadd 10.0.0.24 --save
vzctl set 1024 --nameserver 10.0.0.10 --save
vzctl set 1024 --devices c:4:9:rw --save
vzctl start 1024
vzctl enter 1024
{% endhighlight %}

`NOTE:` you will need access to 13 RPM files from the ISO version of PBX in a Flash so grab the CD so you can get access to the following files-

{% highlight bash %}
c-ares-1.3.2-1.i386.rpm
ez-ipupdate-3.0.11b8-3.i386.rpm
flite-1.3-8.fc7.i386.rpm
flite-devel-1.3-8.fc7.i386.rpm
iksemel-1.2-13.i386.rpm
ircd-hybrid-7.2.1-1.i386.rpm
jpackage-utils-1.7.3-1jpp.2.el5.noarch.rpm
lame-3.97-1.fc6.rf.i386.rpm
lha-1.14i-17.i386.rpm
piafdl-0.1-1.noarch.rpm
piafxtras-0.1-1.noarch.rpm
shared-mime-info-0.19-5.el5.i386.rpm
MySQL-shared-compat-5.0.41-0.rhel4.i386.rpm
{% endhighlight %}

I looked to find them all online but could not (<em>if anyone knows if they are available please let me know and I will update the site</em>)&#59; otherwise I would simply provide the URLs to each file.

Inside of the "fresh" VE I update the root password, copy the RPMs from the CD (see above) and the system using yum&#58;

{% highlight bash %}
passwd
mkdir -p /root/piaf/pbx/
#mount the CD here or SCP the files from the CD (or many other options -- but put the 13 RPMs in /root/piaf/pbx/)
scp -r root@SOME_SYSTEM_WITH_CD_MOUNTED:/mnt/cdrom/pbx/* /root/piaf/pbx/
yum -y update
{% endhighlight %}

Next, I add all of the packages necessary for PBX in a Flash.  This list comes from the <a href="http://pbxinaflash.net/downloads/">ISO CD</a> and the packages that are included across the board for the PBX in a Flash for all cases; I know that it is <strong>NOT</strong> necessary to have all of these packages; however&#59; I just needed the PBX to work and by adding all of the packages ensures you will have every component for the initial instalation&#33;

{% highlight bash %}
yum -y install GConf2 MAKEDEV NetworkManager ORBit2 OpenIPMI OpenIPMI-libs SysVinit acpid alsa-lib alsa-utils amtu anaconda anaconda-runtime anacron apmd apr apr-util arts aspell aspell-en at atk attr audiofile audiofile-devel audit audit-libs audit-libs-python authconfig authconfig-gtk autoconf autofs automake avahi avahi-glib avahi-qt3 basesystem bash bc beecrypt bind bind-libs bind-utils binutils bison bluez-gnome bluez-libs bluez-utils booty busybox-anaconda bzip2 bzip2-libs c-ares cairo ccid cdparanoia-libs centos-release centos-release-notes chkconfig chkfontpath comps-extras conman coolkey coreutils cpio cpp cpuspeed cracklib cracklib-dicts crash createrepo crontabs cryptsetup-luks cups cups-libs curl curl-devel cvs cyrus-sasl cyrus-sasl-lib cyrus-sasl-plain db4 dbus dbus-glib dbus-python dejavu-lgc-fonts desktop-backgrounds-basic desktop-file-utils device-mapper device-mapper-multipath dhcdbd dhclient dhcp dhcpv6-client diffutils dmidecode dmraid dos2unix dosfstools dump

yum -y install e2fsprogs e2fsprogs-devel e2fsprogs-libs ed eject elfutils elfutils-libelf elfutils-libs esound ethtool exim expat fbset file filesystem findutils finger firstboot firstboot-tui flex fontconfig freetype ftp gamin gamin-devel gamin-python gawk gcc gcc-c++ gd gdbm gettext glib2 glib2-devel glibc glibc-common glibc-devel glibc-headers gmp gnome-keyring gnome-mime-data gnome-mount gnome-python2 gnome-python2-bonobo gnome-python2-canvas gnome-python2-gconf gnome-python2-gnomevfs gnome-vfs2 gnupg gnutls gnutls-utils gpm grep groff grub gtk2 gtk2-devel gtk2-engines gzip hal hesiod hicolor-icon-theme htdig htmlview httpd hwdata ibmasm ifd-egate imake info initscripts iproute ipsec-tools iptables iptables-ipv6 iptstate iputils irda-utils irqbalance isdn4k-utils

yum -y install joe jpackage-utils jwhois kbd kdelibs kdnssd-avahi kernel kernel-devel kernel-headers keyutils keyutils-libs keyutils-libs-devel kpartx krb5-devel krb5-libs krb5-workstation ksh kudzu lcms less lftp libFS libICE libIDL libSM libX11 libXScrnSaver libXTrap libXau libXaw libXcomposite libXcursor libXdamage libXdmcp libXext libXfixes libXfont libXfontcache libXft libXi libXinerama libXmu libXpm libXrandr libXrender libXres libXt libXtst libXv libXxf86dga libXxf86misc libXxf86vm libacl libaio libart_lgpl libattr libbdevid-python libbonobo libbonoboui libc-client libcap libdaemon libdhcp libdhcp4client libdhcp6client libdmx libdrm libevent libfontenc libgcc libgcrypt libgcrypt-devel libglade2 libgnome libgnomecanvas libgnomeui libgomp libgpg-error libgpg-error-devel libgssapi libidn libidn-devel libjpeg libmng libnl libnotify libogg libpcap libpng libraw1394 libselinux libselinux-devel libselinux-python libsemanage libsepol libsepol-devel libstdc++ libstdc++-devel libsysfs libtermcap libtermcap-devel libtiff libtiff-devel libtool-ltdl libtool-ltdl-devel libusb libusb-devel libuser libutempter libvolume_id libvorbis libwnck libwvstreams libxkbfile libxml2 libxml2-devel libxml2-python libxslt lksctp-tools lm_sensors logrotate logwatch lsof lvm2

yum -y install m2crypto m4 mailcap mailx make man man-pages mc mcstrans mdadm mesa-libGL mesa-libGLU metacity mgetty microcode_ctl mingetty mkbootdisk mkinitrd mkisofs mktemp mlocate mod_perl module-init-tools mtools mtr mysql mysql-devel mysql-server nano nash nc ncurses ncurses-devel neon net-snmp net-snmp-libs net-tools netpbm netpbm-progs newt newt-devel nfs-utils-lib nmap notification-daemon notify-python nscd nspr nss nss-tools nss_db nss_ldap ntp ntsysv numactl oddjob oddjob openjade openldap opensp openssh openssh-clients openssh-server openssl openssl-devel

yum -y install pam pam_ccreds pam_krb5 pam_passwdqc pam_pkcs11 pam_smb pango pango-devel paps parted passwd patch pax pciutils pcmciautils pcre pcsc-lite pcsc-lite-libs perl perl-Archive-Tar perl-Archive-Zip perl-BSD-Resource perl-Bit-Vector perl-Carp-Clan perl-Compress-Zlib perl-Convert-ASN1 perl-Crypt-SSLeay perl-DBD-MySQL perl-DBD-Pg perl-DBI perl-Date-Calc perl-DateManip perl-Digest-HMAC perl-Digest-SHA1 perl-HTML-Parser perl-HTML-Tagset perl-IO-Socket-INET6 perl-IO-Socket-SSL perl-IO-String perl-IO-Zlib perl-LDAP perl-NKF perl-Net-DNS perl-Net-IP perl-Net-SSLeay perl-Net-Telnet perl-SGMLSpm perl-Socket6 perl-String-CRC32 perl-URI perl-XML-Dumper perl-XML-Grove perl-XML-LibXML perl-XML-LibXML-Common perl-XML-NamespaceSupport perl-XML-Parser perl-XML-SAX perl-XML-Simple perl-XML-Twig perl-libwww-perl perl-libxml-perl perl-suidperl

yum -y install php php-cli php-common php-gd php-imap php-mbstring php-mysql php-pdo php-pear php-pear-DB pinfo pirut pkgconfig pkinit-nss pm-utils policycoreutils popt portmap postfix postgresql-libs ppp prelink procmail procps psacct psmisc pycairo pygobject2 pygtk2 pygtk2 pykickstart pyorbit pyparted python python-elementtree python-numeric python-pyblock python-sqlite python-urlgrabber pyxf86config qt quota rdate rdist readahead readline redhat-artwork redhat-logos redhat-lsb redhat-menus redhat-rpm-config rhpl rhpxl rmt rng-utils rp-pppoe rpm rpm-build rpm-libs rpm-python rsh rsync ruby ruby-libs samba samba-common screen sed selinux-policy selinux-policy-targeted

yum -y install sendmail sendmail-cf setarch setup setuptool sgml-common shadow-utils slang slang-devel smartmontools sos sox specspo speex sqlite squashfs-tools startup-notification stunnel subversion sudo symlinks sysfsutils sysklogd syslinux system-config-date system-config-display system-config-keyboard system-config-kickstart system-config-language system-config-network system-config-network system-config-securitylevel system-config-securitylevel-tui system-config-soundcard system-config-users talk tar tcp_wrappers tcpdump tcsh telnet termcap tftp-server time tmpwatch traceroute tree ttmkfdir tzdata udev unix2dos unixODBC unzip usbutils usermode usermode util-linux
{% endhighlight %}

Next, I install the other RPM files from the disk&#58;

{% highlight bash %}
rpm -Uvh /root/piaf/pbx/c-ares-1.3.2-1.i386.rpm
rpm -Uvh /root/piaf/pbx/ez-ipupdate-3.0.11b8-3.i386.rpm
rpm -Uvh /root/piaf/pbx/flite-1.3-8.fc7.i386.rpm
rpm -Uvh /root/piaf/pbx/flite-devel-1.3-8.fc7.i386.rpm
rpm -Uvh /root/piaf/pbx/iksemel-1.2-13.i386.rpm
rpm -Uvh /root/piaf/pbx/ircd-hybrid-7.2.1-1.i386.rpm
rpm -Uvh /root/piaf/pbx/jpackage-utils-1.7.3-1jpp.2.el5.noarch.rpm
rpm -Uvh /root/piaf/pbx/lame-3.97-1.fc6.rf.i386.rpm
rpm -Uvh /root/piaf/pbx/lha-1.14i-17.i386.rpm
rpm -Uvh /root/piaf/pbx/piafdl-0.1-1.noarch.rpm
rpm -Uvh /root/piaf/pbx/piafxtras-0.1-1.noarch.rpm
rpm -Uvh /root/piaf/pbx/shared-mime-info-0.19-5.el5.i386.rpm
rpm -Uvh /root/piaf/pbx/MySQL-shared-compat-5.0.41-0.rhel4.i386.rpm
{% endhighlight %}

Ok, we are ready to install the PBX software now, finally, run this command&#58;

{% highlight bash %}
/usr/local/sbin/piafdl 14
{% endhighlight %}

The script will ask you if you would like to use option A (to download the PBX load file from the web site; select that option and the PBX load file will download).  The installer will run for a while and will reboot your VPS when the installation is finished.

When the system comes back online add your external IP and local network information into the SIP configuration information in the /etc/asterisk/ folder&#58;

{% highlight bash %}
vi /etc/asterisk/sip_general_custom.conf
{% endhighlight %}

Add these lines to the file where XXX.XXX.XXX.XXX is your public WAN IP address

{% highlight bash %}
externip=XXX.XXX.XXX.XXX
localnet=10.0.0.0/24
{% endhighlight %}

Now, restart Asterisk&#58;

{% highlight bash %}
/usr/local/sbin/amportal restart
{% endhighlight %}

Next, browse to your VPS's WAN IP address (or URL if you have one) and you should see the FreePBX admin center.

