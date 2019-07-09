require 'google_drive'
require 'dotenv/tasks'
require 'dotenv'
require 'colorize'
require 'chronic'
require 'geocoder'
require 'ra11y'

# system requirements
require 'csv'
require 'date'
require 'erb'
require 'json'

# for importing RSS feed
require 'rss'
require 'rss/2.0'
require 'open-uri'
require 'fileutils'
require 'safe_yaml'

require_relative './geocode'
require_relative './google'
require_relative './members'

##
# Utility functions for parsing RSS from https://www.diglib.org/category/ndsa/feed/
module Utils
  def self.format_filename(item)
    "#{Utils.format_date(item)}-#{Utils.format_title(item)}"
  end

  def self.format_date(item)
    item.date.strftime('%Y-%m-%d')
  end

  def self.format_title(item)
    item.title.split(%r{ |!|/|:|&|-|$|,|“|”}).map do |i|
      i.downcase if i != ''
    end.compact.join('-')
  end

  def self.clean_website(url)
    url = "http://#{url}" unless url[/^https?:\/\//] || url.length == 0
    url
  end

  def self.write_file(path, contents)
    begin
      file = File.open(path, 'w')
      file.write(contents)
    rescue IOError => error
      puts "File not writable. Check your permissions"
      puts error.inpsect
    ensure
      file.close unless file == nil
    end
  end

  def self.header(item)
    {
      'layout' => 'post',
      'title' => item.title,
      'date' => item.date.strftime('%Y-%m-%d %T %z')
    }
  end

  def self.write_post(item)
    name = Utils.format_filename(item)
    header = Utils.header(item)

    File.open("_posts/#{name}.html", 'w') do |f|
      puts "Importing #{name}".green
      f.puts header.to_yaml
      f.puts "---\n\n"
      f.puts item.content_encoded
    end
  end
end

##
# Wrapper for RSS functions
module Rss
  def self.import(feed_url)
    open(feed_url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each do |item|
        Utils.write_post(item)
      end
    end
  end
end
