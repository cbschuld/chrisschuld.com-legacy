---
title: Securing Information in dotfiles / aliases / command line in MacOS with Password-Store (pass)
layout: post
tags: macos linux
---

> The intent of this is to give a single walk through on setting up, installing and using pass (password store) on my Mac (macOS) along with [Github](https://github.com/) to maintain sensitive information within my day-to-day operational scripts, aliases and commands.  When I was setting this up initially I could not find a single document with a selfishly direct explanation.  I just wanted a simple system to store a password on a shared encrypted repo, add passwords and use them in a script or command.

<img src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/macbook-typing.jpg" style="width:350px;" width="350" align="right" />
I use a lot of dotfiles, aliases and scripts to manage my day-to-day existence.  A general challenge I have encountered is what to do with privileged and sensitive information.  I do not want the private goodies in my dotfiles repo nor in any project repository.  The question becomes:

>What do I do with all of this sensitive data, passwords and keys?

I needed a way to encrypt the data locally, I need to share it between a few systems, I want to share it via a repository and I need to be able to use it in scripts, aliases and more.

**Solution**: [pass](https://www.passwordstore.org/) or the [Password Store](https://www.passwordstore.org/), [GPG](https://gnupg.org/) and [Github](https://github.com/)

**It provides** a way for me to *encrypt*, *share*, *manage* and use private data with my aliases and scripts.

*NOTE: this is not how I store sensitive information inside of apps; just how I store day-to-day operational private info*

GPG Setup
---------

First, we setup a GPG setup with keys.  If you do NOT have one already; obviously if you use GPG you can chose which fingerprint to use.  Also, make sure you have gpg installed - here is the process assuming macOS.

```bash
brew install gpg gpg2
cd $HOME

```

Github Setup
------------

Pop over to [Github](https://github.com/) to create your password store repository.  Create an empty repo and make sure you note the name of the repo you create and the location.


Pass Setup (macOS)
------------------

You will need two things here, first the name of your password store, in my case I just used my email `cbschuld@gmail.com` and your github repo name; in this example I am using `git@github.com:user/passwordstore.git`

```bash
pass init cbschuld@gmail.com | # just used my email address
pass git init
pass
pass git remote add origin git@github.com:user/passwordstore.git
pass insert Database/db1 | # going to add a password for db1 - it will prompt on stdin and note how I am placing it in a path of "Database"
```

Now, we have [pass](https://www.passwordstore.org/) setup, we added it to github *(almost done with that, stay tuned for two seconds)* and we added a password for this imaginary db1.

We can check to see our passwords just by calling `pass`

```bash
✔ ~
15:38 $ pass
Password Store
└── Database
    └── db1
```

GitHub Updates
--------------

Anytime I update my passwords I simple tell pass to push the updates via:

```bash
pass git push
```

Adding a Password
-----------------

Adding a password is fast; we just *insert* one via `pass`.  Let's add a password for another fictitious dB server called `db2` and let's place it into the `Database` path.

```bash
✔ ~
15:38 $ pass insert Database/db2
Enter password for Database/db2: [typed]
Retype password for Database/db2: [typed]
[master a2cb1d2] Add given password for Database/db2 to store.
```

Getting a Password
------------------

To retrieve a password you simply call `pass` and then the name of the password:
```bash
pass Database/db1
248htasdgq240lkhq24h0fbvai2lk209a8weh2n
```

Using the Passwords
-------------------

Here is an example of using that `db1` password in a call to MySQL

```bash
PASSWD=`pass Database/db1`;  mysql -h db1-cluster.us-west-2.rds.amazonaws.com -u root --password=$PASSWD
```

*NOTE: I saw a lot of folks piping passwords from stdin and expecting pass to just shove the data into stdin.  I did not have success with this because GPG's timeout was too short between usages and instead I set the output password value (or key) to a temporary variable to stop the runtime to intake the master password.*

