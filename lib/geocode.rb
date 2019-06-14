# require_relative './members'
# require_relative './utils'
# require_relative './google'

module Geocode
  # Geocoder.configure(
  #   lookup: :opencagedata,
  #   api_key: ENV['GEOCODER_API_KEY'],
  #   set_timeout: 15
  # )

  def self.new(worksheet)
    @ws = worksheet
    @members = Members.new(worksheet)
  end

  def self.set_coordinates(row)
    @coordinates = {
      organization: @ws[row, 2], # there are multiple columns named 'name'
      street:       @ws[row, Members.headers[:street_address]],
      city:         @ws[row, Members.headers[:city]],
      state:        @ws[row, Members.headers[:state]],
      zip:          @ws[row, Members.headers[:zip_code]],
      longitude:    @ws[row, Members.headers[:longitude]],
      latitude:     @ws[row, Members.headers[:latitude]]
    }
  end

  def self.full_address
      @coordinates.map{ |k, v| v }.join(' ')
  end

  def self.partial_address
    "#{@coordinates[:city]} #{@coordinates[:state]} #{@coordinates[:zip]}"
  end

  def self.geocode_all
    (2..@ws.num_rows).each do |row|
      set_coordinates(row) # sets coordinate hash for row

      puts "  Attempting geocoding on #{@coordinates[:organization]}".yellow
      results = geocode(full_address)

      if results.empty?
        puts "   Couldn't find #{full_address}. Trying #{partial_address}".red
        results = geocode(partial_address)
        puts "       Found #{results[:lon]}, #{results[:lat]}".green
      end

      update_location(row, results)

    end
  end

  def self.geocode_empty
    (2..@ws.num_rows).each do |row|
      set_coordinates(row) # sets coordinate hash for row
      next unless @coordinates[:organization].empty? || @coordinates[:longitude].empty? || @coordinates[:latitude].empty?

      puts "  Attempting geocoding on #{@coordinates[:organization]}".yellow
      results = geocode(full_address)

      if results.empty?
        puts "   Couldn't find #{full_address}. Trying #{partial_address}".red
        results = geocode(partial_address)
        puts "       Found #{results[:lon]}, #{results[:lat]}".green
      end

      update_location(row, results)

    end

  end

  def self.geocode(address)
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

  def self.update_location(row, coordinates)
    @ws[row, Members.headers[:longitude]] = coordinates[:lon]
    @ws[row, Members.headers[:latitude]] = coordinates[:lat]
    @ws.save
  end
end
