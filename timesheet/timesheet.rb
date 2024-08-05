require 'csv'
require 'time'

#TOTAL TIME FUNCTIONS
def time_string_to_seconds(time_str)
  hours, minutes, seconds = time_str.split(':').map(&:to_i)
  hours * 3600 + minutes * 60 + seconds
end

def seconds_to_time_string(seconds)
  hours = seconds / 3600
  minutes = (seconds % 3600) / 60
  seconds = seconds % 60
  format("%02d:%02d:%02d", hours, minutes, seconds)
end
#TOTAL TIME FUNCTIONS END

def clock_in()
    current_date = Date.today.strftime("%m-%d-%Y")
    current_time = Time.now.strftime("%H:%M:%S %p")
    print "Enter In Comment > "
    comment = gets.chomp
  
    data_row = [current_date, current_time, '', '', comment,'']
  
    CSV.open("total-test.csv", 'a') { |csv| csv << data_row }
  end

def clock_out()
    current_time = Time.now.strftime("%H:%M:%S %p")

    print "Enter Out Comment > "
    comment = gets.chomp
  
    csv_data = CSV.read("total-test.csv")
  
    last_row = csv_data[-1]
    last_row[2] = current_time 
    last_row[5] = comment       
    
    #calculate total time difference in seconds 
    time_in = last_row[1] 
    diff = Time.parse(current_time) - Time.parse(time_in)
    total_seconds  = diff.round
    total = Time.at(total_seconds).utc.strftime("%H:%M:%S")

    last_row[3] = total 
  
    CSV.open("total-test.csv", "w") do |csv|
      csv_data.each do |row|
        csv << row
      end
    end
  end

def find_total_time() #add "Total" colunm into single cell at bottom (for now it just prints to console)
  csv_data = CSV.read("total-test.csv").transpose # transpose turns rows into columns
  total_column = csv_data[3] 
  total_column = total_column.slice(1..)#ignore the header

  total_seconds = total_column.inject(0) do |sum, time_str|
    sum + time_string_to_seconds(time_str)
  end

  total_time_string = seconds_to_time_string(total_seconds)

  puts "Total Time: #{total_time_string}" #TODO: write this to a cell
end

puts "Clock in or out? i/o?\nOr f for find_total_time"
option = gets.chomp.downcase
if option == "i"
    clock_in
elsif option == "o"
    clock_out
elsif option == "f"
    find_total_time
end

