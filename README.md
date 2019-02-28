[![Build Status](https://travis-ci.org/clirdlf/ndsa.org.svg?branch=gh-pages)](https://travis-ci.org/clirdlf/ndsa.org)

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

## Content Edits

Interest Group and Working Group co-chairs as well as Coordinating
Committee members are welcome to make content edits to
[ndsa.org](ndsa.org). Please create a GitHub account and e-mail
[ndsa@diglib.org](mailto:ndsa@diglib.org) to get added to the NDSA
GitHub repository.

Content edits can be easily made on the browser-based GitHub editor.
- Find the relevant page (for example, the page for the Standards and
  Practices Interest Group is
[standards-and-practices.md](https://github.com/clirdlf/ndsa.org/blob/gh-pages/standards-and-practices.md))
- Click the pencil icon or type "e" to edit the file
- Make the edits, add a [short description](http://chris.beams.io/posts/git-commit/), and commit the changes to the
  gh-pages branch

For information on formatting, please review the [Markdown
  Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet). GitHub keyboard shortcuts can be found
[here](https://help.github.com/articles/using-keyboard-shortcuts/).

Here are a couple of helpful video tutorials for [**how to add members**](https://drive.google.com/file/d/1zZP02OOE01G-KgDybCFWIIskvCBq62gs/view?usp=sharing) and [**how to update the website**](https://drive.google.com/file/d/1LFqH_dXVgTycB-xSCkjVWXazN57Zi96Y/view?usp=sharing).

## Blog Posts

Blog posts are written and served from https://www.diglib.org/. There is a `rake` task to import these and convert them to the Jekyll format.

```
$ rake import:rss
```

This will load the full content of the posts from the RSS feed and generate the appropriate files. Any changes (typos, links, etc.) need to be made at https://www.diglib.org.

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

# Elections

There is a script to send out emails for elections (`election_mailer.rb`). This has all the code needed to send emails to the contacts, based on the the Google Spreadsheet of members.

## Setup

In the `election_mailer.rb` file, edit the contents of **both** the text and HTML markup (`text_markup` and `html_markup` methods).

## Testing

The top of the file has different delivery methods defined. This line points at a local testing mail server to test everything out *before* this goes out to the community.

### Mail Server

```ruby
Mail.defaults do
  delivery_method :smtp, address: "localhost", port: 1025
end
```

This configuration uses [mailcatcher](https://mailcatcher.me/) to view all the emails to work on any issues that may pop up.

It is really (**REALLY**) important that the other mail configurations are commented out (the lines should start with `#` and Mail.defaults do).

In order to run these tests, you will need the `mailcatcher` mail server running on your machine. In the terminal and type:

```
mailcatcher
```

You will see some output, but the web interface is at [http://127.0.0.1:1080/](http://127.0.0.1:1080/) (the web interface is also where you stop the server).

### Running the Script for Elections

Swap mail configurations by putting # over every line of
  Mail.defaults do
    deliver_method :smpt, address: "localhost", port: 1025
  end

AND

Undoing the `#` in the other mail configurations in

```ruby
  Mail.defaults do
    delivery_method :smtp,
    address:  "smtp.office365.com",
    port:      "587",
    authentication: :login,
    user_name: ENV['SMTP_USERNAME'],
    password:  ENV['SMTP_PASSWORD'],
    domain:   'clir.org',
    enable_starttls_auto: true
  end
```

Save the file. Do **NOT** commit **OR** push this change.

In the terminal (in the `~/projects/ndsa.org/` directory), run `ruby election_mailer.rb`. Open your browser to [http://127.0.0.1:1080/](http://127.0.0.1:1080/) and watch the emails come in.

If there are issues, you can address them at this point.

Undo the changes by swapping mail configurations back to original and save.
