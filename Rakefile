require 'rubygems'
require 'google/api_client'
require 'google_drive'
require 'dotenv/tasks'
require 'colorize'
require 'geocoder'

require 'csv'
require 'date'
require 'erb'
require 'json'

Geocoder.configure(
  :lookup  => :opencagedata,
  :api_key => ENV['430e78b92729e7ecd35a323fa8e95adc'],
  :set_timeout => 15
)

# horrible workaround for OS X
# see https://github.com/google/google-api-ruby-client/issues/253
# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def login
  system('clear') # clear the screen
  Dotenv.load

  puts 'Authorizing...'.green

  access_token = ENV.fetch('ACCESS_TOKEN', '')
  @session = GoogleDrive.login_with_oauth(access_token)
end

def geocode(address)
  result = Geocoder.search(address).first
  {
    :lat => result.latitude,
    :lon => result.longitude
  }
end

task default: 'convert:map'

namespace :pa11y do
  desc "Generate accessibility report for the site"
  task :report do
    puts "Analyzing site at http://localhost:3000"
    `pa11y --reporter html http://localhost:3000 > pa11y.html`
    puts "Finished. You can see the report at ./pa11y.html"
    `open pa11y.html`
  end
end

namespace :convert do
  desc 'Generates GeoJSON of members list'
  task map: :dotenv do

    counter = 0

    json_string = 'var members = {"type": "FeatureCollection",' \
      '"features": ['

    CSV.foreach('tmp/20140131_AllPartnersLoad_NDSA.csv', :encoding=> 'ISO-8859-1', :headers => true) do |row|
    # CSV.foreach('tmp/NDSA_Members_current.csv', :headers => true) do |row|

      @organization = row['Partner Institutions']
      @date         = row['Partner Since'] # format date with strftime?
      @link         = ''
      @lat, @long = ''

      if row['Latitude, Longitude']
        lat_lon = row['Latitude, Longitude'].split(',')
        @lat = lat_lon[0]
        @lon = lat_lon[1]
      end

      # @organization = row['Organization']
      # @address      = row['Address']
      # @address2     = row['Address 2']
      # @date         = row['Date of Initial Signup '] # format date with strftime?
      # @link         = row['Website']
      counter += 1

      # address_string = "#{@organization} #{@address} #{@address2}"
      # result = geocode(address_string)
      #
      # result.latitude == nil? ? @lat = result.latitude : ''
      # result.longitude == nil? ? @lon = result.longitude : ''

      @popup = <<-EOT
        <h2><a href='#{@link}'>#{@organization}</a></h2><p>Partner since <strong>#{@date}</strong></p>
      EOT

      json_string += '{"geometry":{"type":"Point","coordinates":['
      json_string += "#{@lon}, #{@lat}]},"
      json_string += '"type": "Feature", "properties": { "popupContent": "'
      json_string += @popup.strip! + '"'
      json_string += "\n" + '},'
      json_string += "\n" + '"id": ' + "#{counter}"
      json_string += '}'
      json_string += ','

      # get the js template
      # template = ERB.new(File.read('templates/members.js.erb'))
    end

    json_string += ']};'

    puts json_string
  end


  task map_google: :dotenv do
    login
    members_spreadsheet = ENV.fetch('MEMBERS_KEY', '')

    puts "\n\tStarting import from Google Spreadsheet\n\n".green
    for file in @session.files
      puts file.title
    end

    #  @worksheet = @session.spreadsheet_by_key('').worksheets[0]

    # puts @worksheet
  end

  task table: :dotenv do
    json_string = "---
layout: null
permalink: /data/members
---
    ["
    CSV.foreach('tmp/ndsa-members.csv', :encoding=> 'ISO-8859-1', :headers => true) do |row|
      json_string += "{
        \"organization\": \"#{row['Partner Institutions']}\",
        \"state\": \"#{row['State']}\",
        \"focus\": \"#{row['DP Focus']}\"
      },"
    end
    json_string += "]"

    puts json_string

  end


end
