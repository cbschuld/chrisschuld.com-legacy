---
title: Building your own Personal Website in Jekyll
tags: jekyll blog website docker
---

> A simple walk-through for creating a static blog website using Jekyll, a Liquid Theme, hosted on Github pages, using Markdown and Docker for local hosting.


## Background

### Personal Anecdote
In 2007 I created a blog using WordPress and it was generally easy to maintain but authoring was a bit time consuming and getting the performance I wanted was too expensive for a personal notebook and random narratives I wanted to keep or share.  I stopped working on the site between 2011 and 2019 to focus on my business.  In 2019 I decided to dig the site out of the graveyard.  There is a lot of awesome tech currently for constructing static websites.  My favorite note taking format is Markdown and I wanted to base the site on Markdown.  I also wanted to make deployment easy, be able to view the site locally, have a low-cost delivery, serve via HTTPS (*I am a nerd*) and allow me to update it quickly.  I settled on Jekyll using github pages and I use Docker to edit it locally.

### Themes in Jekyll
Themes were the most confusing part of Jekyll for me initially.  There are a lot of themes available but I was looking for something with a minimalist feel and I felt a minimalist approach would give me the fastest way to stand the site back up.  I knew [Mark Otto](http://mdo.fm/) had older themes out there for Jekyll so I went there first.  I am using one of his themes called [Hyde](http://hyde.getpoole.com/) as I feel it gets the job done for me right now.

Themes in Jekyll are a collection of HTML files with specific markup for the [Liquid template language](https://shopify.github.io/liquid/) for Jekyll.  I was expecting the themes to be more complicated but they are simply HTML websites with [Liquid](https://shopify.github.io/liquid/) in them. 

### Assumptions
All of the examples here are done on MacOS but will work in other platforms almost identically. 

### Inventory and TODO List
Before we get started here is the 10,000' view of what we are going to do:
+ Craft content in [Markdown](https://www.markdownguide.org/)
+ Use [Jekyll](https://jekyllrb.com/) for the site
+ Host via [Github Pages](https://pages.github.com/)
+ Use [Docker](https://www.docker.com/) to host locally and see our drafts
+ Make sure deployment is easy
+ Setup our own Domain Name
+ Host via HTTPS

### Decisions you can change easily

+ For this example we are going to use the [Lanyon](https://github.com/poole/lanyon) theme by Mark Otto

## Let's get started

First, in your terminal get to the path you want to build your website, e.g.
```
cd /var/www/
```

Next, we need to create a github repository.  In this example we will call it `jekyll-lanyon-example`.
<img src="/public/images/create-repository-jekyll-lanyon.png" class="screenshot"/>

Next, there are two paths here; you can fork the Lanyon repo **-OR-** you can clone the lanyon repo and flush the git info and establish your own remote origin (what we are going to do).

Clone the lanyon repo to get the theme:
```
git clone https://github.com/poole/lanyon.git
cd lanyon
rm -rfv .git
```

### Update the content of the site

Next, you can open up the lanyon path in your favorite editor and update the content and add your posts

### 

### Use the same version of Jekyll
Check the Jekyll version Github is using by traveling here: [https://pages.github.com/versions/](https://pages.github.com/versions/).  This will tell you what version they are running; next set that version with:
```
export JEKYLL_VERSION=3.7
```
