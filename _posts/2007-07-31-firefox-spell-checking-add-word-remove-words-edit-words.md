---
title: Firefox Spell Checking - Add Word / Remove Words / Edit Words
layout: post
tags: linux fedora
---

<em>Question&#58; I just accidentally added a misspelled word to Firefox's built in dictionary -- how do I remove it?</em>

This is a good question!  Thankfully, someone at Mozilla decided the user dictionary should be stored in plain text and newline delimited.  A big thank you from Chris on this one!

The only challenge is locating your Profile and then your personal / user dictionary file.  The personal dictionary is called <strong>persdict.dat</strong> and lives in your Firefox Profile folder.

The Firefox Profile Folder is located in different places depending on what Operating System you are using&#58;

- Windows XP&#58;<br/>C:\Documents and Settings\%USERNAME%\Application Data\Mozilla\Firefox\Profiles\????????.default\
- Windows Vista&#58;</br/>C:\Users\%USERNAME%\AppData\Roaming\Mozilla\Firefox\Profiles\????????.default\
- Mac OS X&#58;<br/>~/Library/Application Support/Firefox/Profiles/????????.default/
- Linux&#58;<br/>~/.mozilla/firefox/????????.default/

If you are using Windows XP or Windows Vista you can quickly jump to the directory by typing "%APPDATA%\Mozilla\Firefox\Profiles\" into the run box (click on Start-->Run).
<a href='http://chrisschuld.com/wp-content/uploads/2007/07/mozilla-profiles-start-run.png' title='Mozilla Profiles Path'><img src='http://chrisschuld.com/wp-content/uploads/2007/07/mozilla-profiles-start-run.png' alt='Mozilla Profiles Path' /></a>

Once you have found your profile folder you need to edit the persdict.dat file.  Using your favorite text editor open up that file and edit out / add in the words you desire.

You <strong>will need</strong> to restart Firefox before it will see any words you updated.