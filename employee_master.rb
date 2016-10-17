require 'rubygems'
require 'spreadsheet'    

user = Spreadsheet.open('PMT database2.xls')
sheet1 = user.worksheet('Employee Details') # can use an index or worksheet name
sheet1.each do |row|
  puts row[1] # looks like it calls "to_s" on each cell's Value
  #@user = User.new()
  #@user.employee_no = row[1]
  #@user.name = row[2]
  #@user.last_name = row[3]
  #@user.doj = row[4]
  #@user.active = row[6]
end