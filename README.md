# Chris Schuld's Blog

Based on Mark Otto's Hyde Jekyll Template

## Local Development - Building
```shell
export JEKYLL_VERSION=3.7
docker run --env=DEBUG=true --rm --volume="/var/www/chrisschuld.com:/srv/jekyll" -it jekyll/jekyll:$JEKYLL_VERSION jekyll build
```

## Local Development - Execution
```shell
export JEKYLL_VERSION=3.7
docker run --name chrisschuld.com --env=DEBUG=true --rm --volume="/private/var/www/chrisschuld.com/:/srv/jekyll" -p 3000:4000 -it jekyll/jekyll:$JEKYLL_VERSION jekyll serve --watch --drafts
```

## Author

**Chris Schuld**
- <https://github.com/cbschuld>
- <https://twitter.com/cbschuld>


## License

Open sourced under the [MIT license](LICENSE.md).

<3