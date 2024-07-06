#this code works, all that's left is to calculate total by subtracting time_in and time_out
require 'csv'
require 'time'

# columns = ['date','time in','time out','total','comments']
#
# def time_diff_in_seconds(time1, time2)
#   diff = Time.parse(time2) - Time.parse(time1)
#   diff.round
# end

def clock_in()
    current_date = Date.today.strftime("%m-%d-%Y")
    current_time = Time.now.strftime("%H:%M:%S")
    print "Enter In Comment > "
    comment = gets.chomp
  
    data_row = [current_date, current_time, '', '', comment,'']
  
    CSV.open("timesheet.csv", 'a') { |csv| csv << data_row }
  end

def clock_out()
    current_time = Time.now.strftime("%H:%M:%S")

    print "Enter Out Comment > "
    comment = gets.chomp
  
    csv_data = CSV.read("timesheet.csv")
  
    last_row = csv_data[-1]
    last_row[2] = current_time 
    last_row[5] = comment       
    
    #calculate total time difference in seconds 
    time_in = last_row[1] 
    diff = Time.parse(current_time) - Time.parse(time_in)
    total_seconds  = diff.round
    total = Time.at(total_seconds).utc.strftime("%H:%M:%S")

    last_row[3] = total 
  
    CSV.open("timesheet.csv", "w") do |csv|
      csv_data.each do |row|
        csv << row
      end
    end
  end

def find_total_time()
  csv_data = CSV.read("timesheet.csv").transpose # transpose turns rows into columns
  total_column = csv_data[3] 
  p total_column.slice(1..) #ignore the header
end

#I probly worked an hour on this before I went to lunch

find_total_time
# clock_in
# clock_out
