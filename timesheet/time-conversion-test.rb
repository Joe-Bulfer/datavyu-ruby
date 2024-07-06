require 'time'

def seconds_to_hms(seconds)
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end

puts seconds_to_hms(178)

puts seconds_to_hms
puts 2342.class
puts Time.class