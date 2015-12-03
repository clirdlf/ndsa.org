# Getting Started

1. Clone the repo to your projects directory (`mkdir -p ~/projects && git clone git@github.com:clirdlf/ndsa.org.git`). If you have a new computer, you may need to [set up your keys](https://help.github.com/articles/generating-ssh-keys/).
2. Make sure you're on the `gh-pages` branch (`cd ~/projects/ndsa.org && git checkout gh-pages`).
3. Install the dependencies (`bundle install`).
4. And, because of how URLs are constructed on GH, you'll either need to run the `foreman` script with `foreman start`, or run Jekyll directly with `jekyll serve -w --baseurl ""` (this is all the `Procfile` does).

The following script may be of some use. Save it as `/tmp/setup` and run it (e.g. `sh /tmp/setup`):

```
#! /usr/bin/env bash

mkdir -p ~/projects && git clone git@github.com:clirdlf/ndsa.org.git
cd ~/projects/ndsa.org && git checkout gh-pages && bundle install
echo "You can start up the server now with the following command:"
echo "\n\t foreman start"
```
