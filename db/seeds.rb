# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Add super admin Role
r = RoleMaster.create(role_name: "Super Admin", active: 1)
#Add branch 
b = Branch.create(name: 'Main Branch', active:1)
#Add company
c = Company.create(company_name: 'Your company name',
	            email: 'user@yourcompany.com',                
                mobile: '044-77777777'                
                )
c.save!
#add super admin
u = User.create(email: 'superadmin@yourcompany.com',
                name: 'Admin',                
                password: 'passw0rd',
                password_confirmation: 'passw0rd',
                active: 1,
                branch_id: b.id,
                company_id: c.id,
                role_master_id: r.id
                )
u.save!


#Add activity
=begin
["Add Role", "Add Company", "Add Clients", "Add Clients Source", "Add Users", "Add Activity", "Add Branch", "Add Project", "Add Project User", "Add Release Planning", "Add Sprint Planning", "Add Project Task", "Add Task Status Master", "Add Project Status Master", "Add Project Timesheet"].each do |am|
 a = ActivityMaster.create(activity_Name: "#{am}", active: 1)
 RoleActivityMapping.create(role_master_id: r.id, activity_master_id: a.id, access_value: 1, user_id: u.id, active: 1)
end
=end

["Dashboard", "Clients", "Projects", "Release Planning", "Sprint Planning", "Tasks", "Task Board", "TimeSheets", "Reports", "Admin"].each do |al|
a = ActivityMaster.create(activity_Name: "#{al}", active: 1, parent_id:0)
RoleActivityMapping.create(role_master_id: r.id, activity_master_id: a.id, access_value: 1, user_id: u.id, active: 1)
end

#Add Project Users activity
project = ActivityMaster.find_by_activity_Name("Projects")
pro = ActivityMaster.create(activity_Name: "Project Users", active: 1, parent_id: project.id)
RoleActivityMapping.create(role_master_id: r.id, activity_master_id: pro.id, access_value: 1, user_id: u.id, active: 1)
#Add Report sub activity
report = ActivityMaster.find_by_activity_Name("Reports")
["Report1","Report2"].each do |re|
rep = ActivityMaster.create(activity_Name: "#{re}", active: 1, parent_id: report.id)
RoleActivityMapping.create(role_master_id: r.id, activity_master_id: rep.id, access_value: 1, user_id: u.id, active: 1)
end

#add admin sub activity
admin = ActivityMaster.find_by_activity_Name("Admin")
["Users","Roles","Activity"].each do |ad|
ad = ActivityMaster.create(activity_Name: "#{ad}", active: 1, parent_id: admin.id)
RoleActivityMapping.create(role_master_id: r.id, activity_master_id: ad.id, access_value: 1, user_id: u.id, active: 1)
end
