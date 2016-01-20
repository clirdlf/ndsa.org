#! /usr/bin/env ruby
require 'csv'
require 'Time'
require 'Date'
require 'chronic'
# urls = %w(www.thomsonreuters.com http://www.lib.virginia.edu/ https://openvault.wgbh.org http://www.library.northwestern.edu www.cni.org)

def clean_website(link)
  link = "http://#{link}" unless link.nil? || link[/^https?:\/\//]

  link
end

ndsa_users = 'tmp/NDSA_Members_current.csv'
responses = 'tmp/ndsa_responses.csv'

def generate_table_data
  json_string = '---
layout: null
permalink: /data/members.json
---
    ['

    CSV.foreach('tmp/ndsa_responses.csv', :encoding => 'ISO-8859-1', :headers => true) do |row|
      json_string += "{
        \"organization\": \"#{row['Organization Name']}\",
        \"state\": \"#{row['State']}\",
        \"focus\": \"#{row['Digital Preservation Focus']}\"
    },"
    end

    json_string += "]"
end

puts generate_table_data

def generate_map_data

end

# def convert_data
#   CSV.open('tmp/ndsa_responses.csv', 'wb') do |csv|
#     CSV.foreach(ndsa_users, encoding: 'ISO-8859-1', headers: true).each do |row|
#       counter += 1
#
#       timestamp = Chronic.parse(row[0])
#       org_name = row[1]
#       address = row[2]
#       row[3] =~ /^([^,]*),\s*(\w*)\s*(\d*)?$/
#
#       website = clean_website row[4]
#       name = row[5]
#       phone = row[7]
#       email = row[8]
#       sector = ''
#       groups = ''
#       description = ''
#       comm_name = row[9]
#       comm_phone = row[11]
#       comm_email = row[12]
#       auth_name = row[13]
#       auth_phone = row[15]
#       auth_email = row[16]
#
#       csv << [
#         timestamp,
#         org_name,
#         address,
#         Regexp.last_match(1),
#         Regexp.last_match(2),
#         Regexp.last_match(3),
#         website,
#         name,
#         phone,
#         email,
#         sector,
#         groups,
#         description,
#         comm_name,
#         comm_phone,
#         comm_email,
#         auth_name,
#         auth_phone,
#         auth_email
#       ]
#     end
#   end
# end

# convert_data
