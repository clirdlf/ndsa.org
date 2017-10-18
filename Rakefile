#require 'google/api_client'
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

@feed_url = 'https://www.diglib.org/topics/ndsa/feed/'

Dotenv.load

namespace :import do
  desc "Import NDSA feed"
  task :rss do
    open(@feed_url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each do |item|
        formatted_date = item.date.strftime('%Y-%m-%d')
        post_name = item.title.split(%r{ |!|/|:|&|-|$|,|“|”}).map do |i|
          i.downcase if i != ''
        end.compact.join('-')
        name = "#{formatted_date}-#{post_name}"

        header = {
          'layout' => 'post',
          'title' => item.title,
          'date' => item.date.strftime('%Y-%m-%d %T %z')
        }

        FileUtils.mkdir_p("_posts")

        File.open("_posts/#{name}.html", "w") do |f|
          puts "Importing #{name}".green
          f.puts header.to_yaml
          f.puts "---\n\n"
          f.puts item.content_encoded
        end
      end

    end
  end
end

# Geocoder.configure(
#   lookup: :opencagedata,
#   api_key: ENV['GEOCODER_API_KEY'],
#   set_timeout: 15
# )

# horrible workaround for OS X
# see https://github.com/google/google-api-ruby-client/issues/253
# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def login
  system('clear') # clear the screen
  puts 'Authorizing...'.green

  # need rw on https://docs.google.com/spreadsheets/d/1J2wFfkKxxRbDJLUdH5k-ILm12zLuJpgWoRh21dJ2O84/edit
  @session ||= GoogleDrive.saved_session('config.json')
  @ws ||= @session.spreadsheet_by_key(ENV['SPREADSHEET_KEY']).worksheets[0]
end

def geocode(address)
  result = Geocoder.search(address).first
  if result
    {
      lat: result.latitude,
      lon: result.longitude
    }
  else
    {}
  end
end

def update_location(row, longitude, latitude)
  if(longitude == '' || latitude == '')
    address = "#{street}, #{city}, #{state}, #{zip}"
    puts "Looking up #{address}...".yellow
    result = geocode(address)
    @ws[row, 31] = result[:lon]
    @ws[row, 32] = result[:lat]
    @ws.save
    #@ws.reload # not sure if this is necessary; use it for good measure
  else
    puts "Using cached location: (#{longitude},#{latitude})".green
  end
end

def render(template_path)
  template = File.open(template_path, "r").read
  erb = ERB.new(template)
  erb.result(binding)
end

def write_file(path, contents)
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

def spreadsheet
  @ws ||= @session.spreadsheet_by_key(ENV['SPREADSHEET_KEY'])
end

def clean_website(link)
  "http://#{link}" unless link[/^https?:\/\//] || link.length == 0
end

task default: 'convert:all'

namespace :test do
  desc 'Validate HTML output'
  task :html do
    require 'html/proofer'

    `bundle exec jekyll build`
    HTML::Proofer.new('./_site').run
  end

  desc 'Validate site with pa11y'
  task :accessibility do
    sh 'bundle exec jekyll build'
    Ra11y::Site.new('./_site').run
  end
end

namespace :convert do
  desc 'Run all conversions (for map and membership list)'
  task :all => [:table_data, :map, :checksums]

  desc 'Create checksums for the documents directory'
  task :checksums do
    `cd documents && find . -type f -print0 | xargs -0 md5sum >> checksums.md5`
  end


  desc 'Create dataset for data table'
  task table_data: :dotenv do
    login # login and fetch worksheet
    table_data = [] # array to hold data hashes
    header = <<-YAML
---
layout: null
permalink: /data/members.json
---
    YAML
    (2..@ws.num_rows).each do |row|
      active = @ws[row, 30] # row with active switch

      next unless active == 'TRUE'
      row_data = {
        organization: @ws[row, 2],
        state: @ws[row, 5],
        focus: @ws[row, 25]
      }

      table_data << row_data
    end

    file_contents = header + table_data.to_json.to_s
    File.open('data/members.json', 'w') { |f| f.write(file_contents) }
  end

  desc 'Generate GeoJSON from Google Spreadsheet'
  task map: :dotenv do
    login
    system('clear')
    id = 1 # Leaflet likes an id for the point, so fake it
    @features = []

    (2..@ws.num_rows).each do |row|

      feature      = {} # container for feature
      active       = @ws[row, 30] # row with active switch

      if active == 'TRUE'
        feature = {
          id:           id,
          joined:       Chronic.parse(@ws[row, 1]),
          organization: @ws[row, 2],
          street:       @ws[row, 3],
          city:         @ws[row, 4],
          state:        @ws[row, 5],
          zip:          @ws[row, 6],
          website:      clean_website(@ws[row, 7]),
          longitude:    @ws[row, 31],
          latitude:     @ws[row, 32]
        }

        # See if a location has been created
        if(feature[:longitude] == '' || feature[:latitude] == '')
          address = "#{feature[:organization]}, #{feature[:street]}, #{feature[:city]}, #{feature[:state]}, #{feature[:zip]}"
          puts "Looking up #{address}...".yellow
          result = geocode(address)
          @ws[row, 31] = result[:lon]
          @ws[row, 32] = result[:lat]
          @ws.save
          #@ws.reload # not sure if this is necessary; use it for good measure
        else
          puts "Using cached location: (#{feature[:longitude]},#{feature[:latitude]})".green
        end

        id += 1
        puts "Adding #{feature[:organization]}".yellow
        @features << feature
      end


    end

    puts "Rendering JavaScript map data".green
    contents = render('templates/members.js.erb')
    write_file('./data/member_map.js', contents)
  end

end
