---
title: Building your own Personal Website in Jekyll
tags: jekyll blog website docker
---

> A simple walk-through for creating a static blog website using Jekyll, a Liquid Theme, hosted on Github pages, using Markdown and Docker for local hosting.

## Background

### Personal Anecdote
In 2007 I created a blog using WordPress and it was generally easy to maintain but authoring was a bit time consuming and getting the performance I wanted was expensive for a personal notebook and random narratives I wanted to share.  I stopped working on the site between 2011 and 2019 to focus on my business.  In 2019 I decided to dig the site out of the graveyard.  Currently there is a lot of awesome tech for constructing static websites.  My favorite note taking format is Markdown and I wanted to base the site on Markdown if I could.  I also wanted to make deployment easy, be able to view the site locally, have a low-cost delivery, serve via HTTPS (*I am a nerd*) and allow me to update it quickly.  I settled on Jekyll using github pages and I use Docker to edit it locally.

### Themes in Jekyll
Themes were the most confusing part of Jekyll for me initially.  There are a lot of themes available but I was looking for something with a minimalist feel and I felt a minimalist approach would give me the fastest way to stand the site back up.  I knew [Mark Otto](http://mdo.fm/) had older themes out there for Jekyll so I went there first.  I am using one of his themes called [Hyde](http://hyde.getpoole.com/) as I feel it gets the job done for me right now.

Themes in Jekyll are a collection of HTML files with specific markup for the [Liquid template language](https://shopify.github.io/liquid/) for Jekyll.  I was expecting the themes to be more complicated but they are simply HTML websites with [Liquid](https://shopify.github.io/liquid/) in them. 

### Assumptions
All of the examples here are done on MacOS but will work in other platforms almost identically. 

### Inventory and TODO List
Before we get started here is the 10,000' view of what we are going to do:
+ Craft content in [Markdown](https://www.markdownguide.org/)
+ Use [Jekyll](https://jekyllrb.com/) for the site
+ Use [Docker](https://www.docker.com/) to host locally and see our drafts
+ Host via [Github Pages](https://pages.github.com/)
+ Make sure deployment is easy
+ Setup our own Domain Name
+ Host via HTTPS

### Decisions you can change easily

+ For this example we are going to use the [Lanyon](https://github.com/poole/lanyon) theme by Mark Otto

## Let's get started

First, in your terminal get to the path you want to build your website, e.g.
```shell
cd /var/www/
```

Next, we need to create a github repository.  In this example we will call it `jekyll-lanyon-example`.
<img src="/public/images/create-repository-jekyll-lanyon.png" class="screenshot"/>

Next, there are two paths here; you can fork the Lanyon repo **-OR-** you can clone the lanyon repo and flush the git info and establish your own remote origin (what we are going to do).

Clone the lanyon repo to get the theme, remove the git information and rename the path to our `jekyll-lanyon-example`
```shell
git clone https://github.com/poole/lanyon.git
rm -rfv lanyon/.git
mv lanyon jekyll-lanyon-example
```

Now we have the site at `/var/www/jekyll-lanyon-example`

### Craft content in Markdown

Time to update the content of the site using Markdown.  Open up the lanyon path in your favorite editor and update the content and add your posts.  This will likely be the first step in the iterative process for the site.

### Now we will use Jekyll to serve the content

#### First, use the same version of Jekyll as Github
Check the Jekyll version Github is using by traveling here: [https://pages.github.com/versions/](https://pages.github.com/versions/).  This will tell you what version they are running; next set that version with:
```shell
export JEKYLL_VERSION=3.7
```

#### Versions, versions, so many versions...
Mark's `_config.yml` file is a bit dated (*as of 2019-02-27 based on version 3.7 of Jekyll so you have to change it a bit*), the new _config.yml file should look like this:
```yaml
# Permalinks
#
permalink:           /:categories/:year/:month/:day/:title/

# Setup
title:               My Title
tagline:             My Own Webiste
description:         Some Amazing Description
url:                 http://yoururl.com
baseurl:             ''
paginate:            5

# Plugins, Tags, Categories and Analytics  
plugins:          [jekyll-paginate]

# About/contact
author:
  name:              Your Name
  url:               https://yoururl.com
  email:             you@gmail.com
```

#### Now, let's use Docker to serve the content locally
To have Docker serve the content locally you must first understand where the content is at on your disk.  Understand what path you used to pull in the Lanyon repository.

e.g. for our path we will assume `/var/www/jekyll-lanyon-example` - you will see the path in the Docker build command

```shell
docker run --env=DEBUG=true --rm --volume="/var/www/jekyll-lanyon-example:/srv/jekyll" -it jekyll/jekyll:$JEKYLL_VERSION jekyll build
```

After the build is complete you can run it with draft mode with this command:
```shell
docker run --name mydomain.com --env=DEBUG=true --rm --volume="/var/www/jekyll-lanyon-example:/srv/jekyll" -p 3000:4000 -it jekyll/jekyll:$JEKYLL_VERSION jekyll serve --watch --drafts
```

<img src="/public/images/jekyll-running-locally-for-example.png" class="screenshot"/>

And now it works via [http://localhost:3000](http://localhost:3000)

<img src="/public/images/lanyon-running.png" class="screenshot"/>

### Host via Github Pages
Now we need to get the content up to our repository we created above.

#### Commit to Github
Make sure you swap out **your repo** with the repo below
```shell
git init
git add .
git commit -am 'initial commit'
git remote add origin git@github.com:cbschuld/jekyll-lanyon-example.git
git push -u origin master
```

<img src="/public/images/lanyon-adding-to-github.png" class="screenshot">

#### Turn on pages
After you commit to Github you will have a master branch.  Click on your repository and go to settings (look for the cog).  From there head down to Github Pages.

From there, select **Master Branch** and it will be hosted... wait a few minutes and you can go directly to the URL they provide!

<img src="/public/images/lanyon-master-branch-github-pages.png" class="screenshot">



### You did it!
Now to add content just push changes to your **master** branch and the changes will appear in minutes!