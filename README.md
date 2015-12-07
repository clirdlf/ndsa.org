# Getting Started

1. Clone the repo to your projects directory (`mkdir -p ~/projects && git clone git@github.com:clirdlf/ndsa.org.git`). If you have a new computer, you may need to [set up your keys](https://help.github.com/articles/generating-ssh-keys/).
2. Make sure you're on the `gh-pages` branch (`cd ~/projects/ndsa.org && git checkout gh-pages`).
3. Install the dependencies (`bundle install`).

The following script may be of some use. Save it as `/tmp/setup` and run it (e.g. `sh /tmp/setup`):

```
#! /usr/bin/env bash

mkdir -p ~/projects && git clone git@github.com:clirdlf/ndsa.org.git
cd ~/projects/ndsa.org && git checkout gh-pages && bundle install
```
