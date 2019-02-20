---
title: Dumping Addresses from phplist
layout: post
tags: php
---

We recently moved away from phplist (goodbye phplist — we loved you for a while but now we need more power). Here is the SQL used to rip our users out of the main list. Attributes 1 and 2 are the first and last name.

{% highlight sql %}
SELECT DISTINCT
    phplist_user_user.email AS Email,
    phplist_user_user_attribute1.value AS FirstName,
    phplist_user_user_attribute2.value AS LastName
FROM
    phplist_user_user
JOIN
    phplist_user_user_attribute AS phplist_user_user_attribute1 ON ( phplist_user_user_attribute1.userid = phplist_user_user.id AND phplist_user_user_attribute1.attributeid = 1 )
JOIN
    phplist_user_user_attribute AS phplist_user_user_attribute2 ON ( phplist_user_user_attribute2.userid = phplist_user_user.id AND phplist_user_user_attribute2.attributeid = 2 )
JOIN
    phplist_listuser ON ( phplist_listuser.userid = phplist_user_user.id AND phplist_listuser.listid = 1 )
WHERE
    phplist_user_user.blacklisted = 0
{% endhighlight %}