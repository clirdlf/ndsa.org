require 'erb'

module Members
  def self.new(worksheet)
    @ws = worksheet
  end

  def self.render(template_path)
    template = File.open(template_path, 'r').read
    erb = ERB.new(template)
    erb.result(binding)
  end

  def self.headers
    @headers ||= {}
    counter = 1
    (1..@ws.num_cols).each do |col|
      @headers[@ws[1, col].gsub(/\s+/, '_').downcase.to_sym] = counter
      counter += 1
    end

    @headers
  end

  def self.json_header
  <<-YAML
---
layout: null
permalink: /data/members.json
---
YAML
  end

  def self.feature(row, id)
    {
      id: id,
      joined: Chronic.parse(@ws[row, headers[:timestamp]]),
      organization: @ws[row, 2], # there are multime :name columns
      street: @ws[row, headers[:street_address]],
      city: @ws[row, headers[:city]],
      state: @ws[row, headers[:state]],
      zip: @ws[row, headers[:zip_code]],
      website: Utils.clean_website(@ws[row, headers[:website]]),
      longitude: @ws[row, headers[:longitude]],
      latitude: @ws[row, headers[:latitude]]
    }
  end

  def self.write_geojson
    id = 1 # fake id for leaflet
    @features = []

    (2..@ws.num_rows).each do |row|
      next unless @ws[row, headers[:active]] == 'TRUE'

      @features << feature(row, id)
      id += 1
    end

    puts '  Rendering JavaScript map data to data/member_map.js'.green
    contents = render('./templates/members.js.erb')
    Utils.write_file('./data/member_map.js', contents)
  end

  def self.write_json
    puts '  Writing data/members.json...'.green
    table_data = []

    (2..@ws.num_rows).each do |row|
      # only parse items with TRUE for active column
      next unless @ws[row, headers[:active]] == 'TRUE'

      row_data = {
        organization: @ws[row, 2], # there are two name fields
        state: @ws[row, headers[:state]],
        focus: @ws[row, headers[:digital_preservation_focus]]
      }

      table_data << row_data


    end

    file_contents = json_header + table_data.to_json.to_s
    File.open('data/members.json', 'w') { |f| f.write(file_contents) }

    count = table_data.count.to_s
    File.open("_data/members.yml", "w") { |f| f.write("count: " + count) }
  end
end
