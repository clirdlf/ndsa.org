require_relative 'lib/utils'

FEED_URL = 'https://www.diglib.org/category/ndsa/feed/'

Dotenv.load

task default: %w(convert:all import:rss)

namespace :import do
  desc "Import NDSA feed"
  task :rss do
    Rss.import(FEED_URL)
  end
end

namespace :test do
  desc 'Validate HTML output'
  task :html do
    require 'html-proofer'
    `bundle exec jekyll build`
    options = {
      assume_extension: true,
      disable_external: true,
      empty_alt_ignore: true,
      url_swap: { "^/" => "http://localhost/" }
    }
    HTMLProofer.check_directory("./_site", options).run
    # HTML::Proofer.new('./_site').run
  end

  desc 'Validate site with pa11y'
  task :accessibility do
    sh 'bundle exec jekyll build'
    Ra11y::Site.new('./_site').run
  end
end

namespace :geocode do
  desc 'Geocode all records'
  task :all do
    Google.login
    Geocode.new(Google.worksheet)
    Geocode.geocode_all
  end

  desc 'Geocode members who do not have lon/lat'
  task :empty do
    Google.login
    Geocode.new(Google.worksheet)
    Geocode.geocode_empty
  end

end

namespace :convert do
  desc 'Run all conversions (for map and membership list)'
  task :all => [:table_data, :checksums]

  desc 'Create checksums for the documents directory'
  task :checksums do
    `cd documents && find . -type f -print0 | xargs -0 md5sum >> checksums.md5`
  end

  desc 'Create dataset for data table'
  task table_data: :dotenv do
    Google.login
    Members.new(Google.worksheet)
    Members.write_json
  end

  desc 'Generate GeoJSON from Google Spreadsheet'
  task members_map: :dotenv do
    Google.login
    Members.new(Google.worksheet)
    Members.write_geojson
  end

end
