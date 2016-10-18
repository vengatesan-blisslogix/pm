require 'rubygems'
require 'spreadsheet'    

user = Spreadsheet.open('PMT database2.xls')
sheet1 = user.worksheet('Employee Details') # can use an index or worksheet name
sheet1.each do |row|
  puts row[7] # looks like it calls "to_s" on each cell's Value
  #@user = User.new()
  #@user.employee_no = row[0]
  #@user.name = row[1]
  #@user.last_name = row[2]
  #@user.doj = row[3]
  #@user.active = row[4]
  #@user. = row[4]
  #@user.prior_experience = row[6]
  #@user.reporting_to	= row[7]
end