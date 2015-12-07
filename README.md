# Getting Started
1. Clone the repo to your projects directory (`mkdir -p ~/projects && git clone git@github.com:clirdlf/ndsa.org.git`). If you have a new computer, you may need to [set up your keys](https://help.github.com/articles/generating-ssh-keys/).
2. Make sure you're on the `gh-pages` branch (`cd ~/projects/ndsa.org && git checkout gh-pages`).
3. Install the dependencies (`bundle install`).

```
#! /usr/bin/env bash

mkdir -p ~/projects && git clone git@github.com:clirdlf/ndsa.org.git
cd ~/projects/ndsa.org && git checkout gh-pages && bundle install
```

## Local Development
- Use [Atom](https://atom.io/)
- Use the [Jekyll-Atom](https://github.com/arcath/jekyll-atom) plugin
- Start the server (Packages -> Jekyll -> Open Toolbar) and click **Start/Stop Server**
- Open your browser to [http://localhost:3000](http://localhost:3000)

Every time you save a change, Jekyll will rebuild the website.
