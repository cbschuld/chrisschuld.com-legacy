---
title: "Waiting for MySQL in Docker (Github Workflow/Actions)"
layout: post
tags: dev docker
---

## Summary

Using automated CI/CD and testing with MySQL in Docker can create some unique challenges (*especially as you start doing things in parallel*).

You may get odd errors out of your test environment that would resemble the MySQL instance not being available:

```
  NetworkingError: socket hang up
```

## Docker - `depends_on`

When Docker switched from v2 to v3 they did not take with them the options for `depends_on` so you can no longer "hold" for a specific status.  Instead you need to use some external way to sense when the dB is available.  Docker essentially exits after the container is alive and not necessarily when the services are available in the container.  You need a different strategy for this.

## Waiting for the daemon

One nice way to wait is to use `mysqladmin ping` but this does not necessarily tell you the privilege tables are ready so it has some oddities.

The way around this is to use this script:

`wait-for-mysql.sh`:
```shell
#!/bin/sh

CONTAINER="xxx"
USERNAME="uuu"
PASSWORD="ppp"
while ! docker exec $CONTAINER mysql --user=$USERNAME --password=$PASSWORD -e "SELECT 1" >/dev/null 2>&1; do
    sleep 1
done
```

This script will exit when the database is actually ready.  The use of `mysqladmin ping` is not 100% reliable.

## Waiting for MySQL with Github Workflow / Actions

In GitHub Workflow and actions you can now do this (*example*):

```yaml
      - name: testing with MySQL
        run: |
          docker network rm $(docker network ls -q) || true
          docker-compose -f docker/mysql.yml up -d
          echo 'pausing: waiting for mysql to come available'
          ./wait-for-mysql.sh
          echo 'un-pausing: mysql is now available'
          npm run test-mysql -- --runInBand --ci
          docker-compose -f docker/mysql.yml down -v
```
