
def report_3
# Create a new Excel Workbook
date = Time.now.strftime("%m/%d/%Y")
date1 = Time.now.strftime("%m-%d-%Y")

@end_date = Date.today
@start_date = @end_date-5

@file_name = "Categorywise_project_Report.xls"
workbook = WriteExcel.new("#{Rails.root}/#{@file_name}")

# Add worksheet(s)
worksheet1  = workbook.add_worksheet

# Add and define a format

format = workbook.add_format
format.set_bold
format.set_size(10)
format.set_bg_color('cyan')
format.set_color('black')
format.set_border(1)

format1 = workbook.add_format
format1.set_size(10)
format1.set_color('black')
format1.set_text_wrap(1)
format1.set_align('top')

worksheet1.set_column('A:A', 20,format1)
worksheet1.set_column('B:B', 25,format1)
worksheet1.set_column('C:C', 25,format1)
worksheet1.set_column('D:D', 25,format1)
worksheet1.set_column('E:E', 25,format1)
worksheet1.set_column('F:F', 25,format1)


worksheet1.set_row(0,20)

# write a formatted and unformatted string.
worksheet1.write(0,0, 'No', format)
worksheet1.write(0,1, 'Billable Type', format)
worksheet1.write(0,2, 'Project Name', format)
worksheet1.write(0,3, 'Billable hour', format)
worksheet1.write(0,4, 'Non-Billable hour', format)
worksheet1.write(0,5, 'Total hour', format)


row=1
@user_all = User.all

@user_all.each do |u|
worksheet1.write(row,1, "#{u.name}", format1)
@team = TeamMaster.find_by_id(u.team_id)
if @team != nil
  @team_name = @team.team_name
else
  @team_name = "-"
end
worksheet1.write(row,2, "#{@team_name}", format1)

@find_project_for_user = ProjectUser.where("user_id=#{u.id}")
@project_id = ""
@find_project_for_user.each do |pu|
if @project_id == ""
@project_id = pu.project_master_id
else
@project_id = @project_id.to_s+","+pu.project_master_id.to_s
end
end#@find_project_for_user.each do |pu|

if @project_id!=""
@project_all = ProjectMaster.where("id IN(#{@project_id})")
@pro_name=""
@project_all.each do |pro|
if @pro_name == ""
@pro_name = pro.project_name
else
@pro_name = @pro_name+", "+pro.project_name
end
end#@project_all.each do |pro|
else
  @pro_name="-"
end


workbook.close

#send_file("#{@file_name}" ,
  #    :filename     =>  "#{@file_name}",
  #    :charset      =>  'utf-8',
  #    :type         =>  'application/octet-stream')

end