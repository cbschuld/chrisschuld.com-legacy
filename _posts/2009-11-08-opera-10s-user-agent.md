---
title: Opera 10's User Agent
layout: post
tags: php
---

For those of you who detect Opera 10's user agent, the Opera team has provide some "fun" for all of us.  In my B<a href="http://chrisschuld.com/projects/browser-php-detecting-a-users-browser-from-php/">rowser project</a> I started getting feedback that it was broken.  At the 10,000' level, it was defintely broken because the <a href="http://chrisschuld.com/projects/browser-php-detecting-a-users-browser-from-php/">Browser project</a> was returning version 9.8 for Opera version 10.

This is because the Opera dev team decided to leave the version 9.8 user agent string the same and tack on version 10 to end of the string.  You can <a href="http://dev.opera.com/articles/view/opera-ua-string-changes/">read more about it on their blog</a>.

For those of you using my <a href="http://chrisschuld.com/projects/browser-php-detecting-a-users-browser-from-php/">Browser project</a> have no fear; the new version (1.6+) handles the oddity!