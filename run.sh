#!/bin/sh
JEKYLL_VERSION=3.7
docker run --name chrisschuld.com --env=DEBUG=true --rm --volume="/private/var/www/chrisschuld.com/:/srv/jekyll" -p 3000:4000 -it jekyll/jekyll:$JEKYLL_VERSION jekyll serve --watch --drafts
