require 'csv'

columns = ['Date','Time In','Time Out','Total','In Comment','Out Comment']

=begin
do...end in ruby is equivelent to wrapping a block of code in curly braces {} in other languages. 
The following do the exact same thing, create a csv file with the same header/row. Though we will stick with the do..end for adding additional rows  
The "<<" is typically for appending elements to arrays. Here it adds appends rows to our spreadsheet.
=end

CSV.open('timesheet.csv', 'w') {|csv| csv << columns}

CSV.open('timesheet.csv', 'w') do |csv|
    csv << columns
en
