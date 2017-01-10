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

## Blog Posts

Blog posts are written and served from https://diglib.org/. There is a `rake` task to import these and convert them to the Jekyll format.

```
$ rake import:rss
```

This will load the full content of the posts from the RSS feed and generate the appropriate files. Any changes (typos, links, etc.) need to be made at https://diglib.org. 

## Membership Data

There are `Rake` tasks that will retrieve data from the Google Spreadsheet where the application data is saved. By default, you only need to run `rake` in the project directory.

```
$ rake
```

This will generate new files needed by the `members-list` page.

```
rake
git commit -am "Added [organization] to the members-list page"
```

> The applicant's `active` field needs to be set to `TRUE` (**ALL CAPS**) or these scripts will skip over the processing.

## Validating HTML
This app uses [html-proofer](https://rubygems.org/gems/html-proofer) to validate
HTML (especially links and whatever). All of the dependencies are installed via
`bundler` and executed via `rake` task:

```
$ rake test:html
```

## Accessibility

We're using [pa11y](https://github.com/nature/pa11y) for accessibility testing.

### Installation

You will need to make sure you have [npm](https://www.npmjs.com/) installed.
Easiest way on OS X is with [brew](http://brew.sh/).

```
$ brew install npm
$ npm install -g phantomjs pa11y
$ gem install
```

### Generating a Report

There is a `Rake` task that will generate the appropriate report:

```
$ rake test:accessibility
```
