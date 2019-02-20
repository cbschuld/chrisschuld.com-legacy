---
title: Browser.php - version 1.1 - released!
layout: post
tags: php
---

I updated the <a href="http://chrisschuld.com/projects/browser-php-detecting-a-users-browser-from-php/">Browser.php class</a> today to detect Google's Chrome Browser.  Additionally, thanks to an idea from <a href="http://mavrick.id.au/">Daniel 'mavrick' Lang</a>, I added <strong>isBrowser($browserName)</strong> as a function to version 1.1.


Visit the <a href="http://chrisschuld.com/projects/browser-php-detecting-a-users-browser-from-php/">Browser.php class page</a> today to grab the update!


Interested in a PHP4 version?  Daniel is <a href="http://mavrick.id.au/programming/2008/the-all-new-php-browser-detection/">maintaining a version for PHP4</a>.

Example Usage:
{% highlight php %}


$browser = new Browser();
if( ! ( $browser->getBrowser() == Browser::BROWSER_FIREFOX && $browser->getVersion() >= 2 ) ) {
	echo 'You have FireFox version 2 or greater';
}
{% endhighlight %}
// AND NOW...

{% highlight php%}
if( $browser->isBrowser(Browser::BROWSER_CHROME) ) {
	echo '<p><strong>Hi Google Chrome User!</strong></p>';
}
{% endhighlight %}