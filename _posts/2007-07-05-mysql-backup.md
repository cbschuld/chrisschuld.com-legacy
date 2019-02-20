---
title: MySQL Backup
layout: post
tags: linux
tags: mysql php
---

One of the challenges of maintaining a <a href="http://mysql.com" target="_blank">MySQL</a> server loaded with customer data is backing up the customer data on timed intervals without editing the backup
script(s) each time you add a customer or database. I wrote this script to process the backups automatically for me.

{% highlight bash %}#!/bin/sh
#
# Script places all backup files in the current working directory
#
DB_USER=user
DB_PASS=password
DB_HOST=localhost
MYSQL_DUMP_OPTIONS="--add-locks --allow-keywords --extended-insert --lock-all-tables"

DATE_TIME=`date +%Y%m%d.%H%M%S`

for db in `echo "show databases;" | mysql -h $DB_HOST -u $DB_USER --password="$DB_PASS" | grep -v -P "(Database|information_schema|test)"`
do
        mysqldump $MYSQL_DUMP_OPTIONS -h $DB_HOST -u $DB_USER --password="$DB_PASS" $db | gzip &gt; $db.$DATE_TIME.sql.gz
done
{% endhighlight %}