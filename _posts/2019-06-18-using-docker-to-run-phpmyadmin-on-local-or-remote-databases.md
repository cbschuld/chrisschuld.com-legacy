---
title: Using Docker to run phpMyAdmin on local or remote databases
layout: post
tags: docker php database
---

>I have found that I use [phpMyAdmin](https://www.phpmyadmin.net/) more than I want to admit to anyone for MySQL, MariaDB or AWS Aurora development iteration.  The team working on phpMyAdmin does such a great job with the tool.  However, it is somewhat of a pain to run it locally or on a network near your database.  You have to setup a server, have PHP working 100%, etc.  Docker makes this infinitely easier.  You can run phpMyAdmin on a local (or even remote) database.  All you need to know is the hostname; let Docker and this image do the rest.

Initialize the container(s)
---------------------------

We will use these example databases:

    db21 at db21.cluster.us-west-2.rds.amazonaws.com
    d44 at 10.0.0.44
    
Here is how I do the first example:
```bash
docker run --name db21 -d -e PMA_HOST=db21.cluster.us-west-2.rds.amazonaws.com -p 8021:80 phpmyadmin/phpmyadmin 
```

Notice how I change the PMA_HOST, the name of the container and the port it is used; this way I know that if I want to manage `db21` via phpMyAdmin I simply browse to [http://localhost:8021](http://localhost:8021)

The second example:
```bash
docker run --name db44 -d -e PMA_HOST=10.0.0.44 -p 8044:80 phpmyadmin/phpmyadmin 
```

Again, I change the PMA_HOST, the name of the container and the port it is used; this way I know that if I want to manage `d44` via phpMyAdmin I simply browse to [http://localhost:8044](http://localhost:8044)

When you run this the first time docker will need to pull down the latest image of phpmyadmin/phpmyadmin.  This may take a bit; but after the container is pulled down starting, stopping, and reloading the container is straight forward:

Stopping the container(s)
-------------------------
```bash
docker stop db21
docker stop d44
docker stop [name_of_your_db_container]
```

Starting (or Restarting) the container(s)
-----------------------------------------
```bash
docker start db21
docker start d44
docker start [name_of_your_db_container]
```

*NOTE: this is essentially my summary of this docker article: [https://hub.docker.com/r/phpmyadmin/phpmyadmin/](https://hub.docker.com/r/phpmyadmin/phpmyadmin/)*


