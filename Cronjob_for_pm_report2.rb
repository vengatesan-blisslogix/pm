def report_2
# Create a new Excel Workbook
date = Time.now.strftime("%m/%d/%Y")
date1 = Time.now.strftime("%m-%d-%Y")

@end_date = Date.today
@start_date = @end_date-5

d = DateTime.now

@file_name = "Resourcewise_project_Report_#{d}.xls"
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
worksheet1.set_column('G:G', 25,format1)


worksheet1.set_row(4,20)

# write a formatted and unformatted string.
worksheet1.write(4,0, 'No', format)
worksheet1.write(4,1, 'User Name', format)
worksheet1.write(4,2, 'Project Name', format)
worksheet1.write(4,3, 'Sprint Name', format)
worksheet1.write(4,4, 'Billable hour', format)
worksheet1.write(4,5, 'Non-Billable hour', format)
worksheet1.write(4,6, 'Total hour', format)


row=5
serial=1

  @users=User.all
  @users.each do |u|
    worksheet1.write(row,0, serial, format1)
    worksheet1.write(row,1, "#{u.name}#{u.last_name}", format1)

      @project_user = ProjectUser.where("user_id = #{u.id}")

        @project_user.each do |pu|
          @project_name = ProjectMaster.find_by_id(pu.project_master_id)
            worksheet1.write(row,2, "#{@project_name.project_name}", format1)
         @find_assign = Assign.where("assigned_user_id =#{pu.user_id}")
            @sprint_id = ""
            @find_assign.each do |fa|

              @sprint = Taskboard.where("id = #{fa.taskboard_id}")
                if @sprint != "" and @sprint != nil   and @sprint.size != 0   
                    if @sprint_id==""
                      @sprint_id=@sprint[0].sprint_planning_id
                    else
                      @sprint_id=@sprint_id.to_s+","+@sprint[0].sprint_planning_id.to_s
                    end
                end
               end
                if @sprint_id != ""
                  @sprint_planning = SprintPlanning.where("id IN(#{@sprint_id})")
                  @sprint_planning.each do |sp|
                  @sprint_name = sp.sprint_name
                  worksheet1.write(row,3, "#{@sprint_name}", format1)


            @timesheet_summ_user_time = Logtime.where("sprint_planning_id=#{sp.id} and project_master_id=#{pu.id} and user_id=#{pu.user_id}").sum(:task_time)
                    if pu.is_billable == 'yes'
                                worksheet1.write(row,4, "#{@timesheet_summ_user_time}", format1)
                    else
                        worksheet1.write(row,5, "#{@timesheet_summ_user_time}", format1)
                    end
                        worksheet1.write(row,6, "#{@timesheet_summ_user_time}", format1)

                    row = row +1
                end
          else
            worksheet1.write(row,3, "---", format1)

            row = row +1
          end
      end
  serial = serial + 1
end
workbook.close

#send_file("#{@file_name}" ,
  #    :filename     =>  "#{@file_name}",
  #    :charset      =>  'utf-8',
  #    :type         =>  'application/octet-stream')

end
