require 'rubygems'
require 'google_drive'
require 'dotenv/tasks'
require 'colorize'

require 'date'

def login
  system('clear') # clear the screen

  @client = Google::APIClient.new(
    application_name: 'NDSA',
    application_version: '1.0'
  )

  auth                = @client.authorization
  auth.client_id      = @@CLIENT_ID
  auth.client_secret  = @@CLIENT_SECRET

  auth.scope =
    'https://www.googleapis.com/auth/drive ' \
    'https://spreadsheets.google.com/feeds/'
  auth.redirect_uri = 'urn:ietf:wg:oauth:2.0:oob'

  puts 'Authorizing...'.green

  print("\n1. Open this page:\n%s\n\n" % auth.authorization_uri)
  print('2. Enter the authorization code shown in the page: ')

  auth.code = $stdin.gets.chomp
  auth.fetch_access_token!
  access_token = auth.access_token

  @session = GoogleDrive.login_with_oauth(access_token)
end

task default: 'convert:map'

namespace :convert do
  desc 'Generates GeoJSON of members list'
  task map: :dotenv do
    @@MEMBERS_KEY   = ENV.fetch('MEMBERS_KEY', '')
    @@CLIENT_ID     = ENV.fetch('CLIENT_ID', '')
    @@CLIENT_SECRET = ENV.fetch('CLIENT_SECRET', '')

    login

    puts "Starting import from Google Spreadsheet\n\n"
    @worksheet = @session.spreadsheet_by_key(MEMBERS_KEY).worksheets.first

    puts @worksheet
  end
end
