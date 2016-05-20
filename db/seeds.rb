# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Add activity
=begin
["Add Role", "Add Company", "Add Clients", "Add Clients Source", "Add Users", "Add Activity", "Add Branch", "Add Project", "Add Project User", "Add Release Planning", "Add Sprint Planning", "Add Project Task", "Add Task Status Master", "Add Project Status Master", "Add Project Timesheet"].each do |am|
 a = ActivityMaster.create(activity_Name: "#{am}", active: 1)
 RoleActivityMapping.create(role_master_id: r.id, activity_master_id: a.id, access_value: 1, user_id: u.id, active: 1)
end
=end



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




href = ["home.dashboard", "home.clients", "home.projects", "home.projectUsers", "home.releasePlanning", "home.sprintPlanning", "home.tasks",  "home.taskBoard", "home.timesheets", "home.reports", "home.admin"]

icon = ["fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer"]
i = 0

["Dashboard", "Clients", "Projects", "Project Users", "Release Planning", "Sprint Planning", "Tasks", "Task Board", "TimeSheets", "Reports", "Admin"].each do |al|
a = ActivityMaster.create(activity_Name: "#{al}", active: 1, parent_id:0, href: href[i],  icon: icon[i])
RoleActivityMapping.create(role_master_id: r.id, activity_master_id: a.id, access_value: 1, user_id: u.id, active: 1)
i = i+1
end

#Add Project Users activity
#project = ActivityMaster.find_by_activity_Name("Projects")
#pro = ActivityMaster.create(activity_Name: "Project Users", active: 1, parent_id: project.id, href: "home.projectUsers", icon: "fa fa-fw fa-tachometer")
#RoleActivityMapping.create(role_master_id: r.id, activity_master_id: pro.id, access_value: 1, user_id: u.id, active: 1)
#Add Report sub activity
report = ActivityMaster.find_by_activity_Name("Reports")
href = ["home.report1", "home.report2"]
icon = ["fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer"]
i = 0
["Report1","Report2"].each do |re|
rep = ActivityMaster.create(activity_Name: "#{re}", active: 1, parent_id: report.id, href: href[i],  icon: icon[i])
RoleActivityMapping.create(role_master_id: r.id, activity_master_id: rep.id, access_value: 1, user_id: u.id, active: 1)
i = i+1
end

#add admin sub activity
href = ["home.users", "home.roles", "home.activity","home.branch"]
icon = ["fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer"]
i = 0
admin = ActivityMaster.find_by_activity_Name("Admin")
["Users","Roles","Activity","Branch"].each do |ad|
ad = ActivityMaster.create(activity_Name: "#{ad}", active: 1, parent_id: admin.id, href: href[i],  icon: icon[i])
RoleActivityMapping.create(role_master_id: r.id, activity_master_id: ad.id, access_value: 1, user_id: u.id, active: 1)
i = i+1
end

#add client source
["Elance","Guru","Direct","BAT","Others","Confenrence"].each do |cs|
ClientSource.create(source_name:"#{cs}", description: "#{cs}", active: 1, user_id: u.id)
end

#project status master add 
["Assigned","In progress","On Hold","Development Completed","Pending Payment","Closed"].each do |ps|
ProjectStatusMaster.create(status:"#{ps}", active: 1, user_id: u.id)
end

#add project domain
#["Finance and Insurance","Real Estate and Rental and Leasing","Retail Trade","Health Care and Social Assistance","Educational Services","Management of Companies and Enterprises",""]
["Enterprise Mobility","Custom Mobile Development","Web development","UX / UI","Web & Mobile QA","IoT & Wearables","Analytics"].each do |pd|
ProjectDomain.create(domain_name:"#{pd}", active: 1, user_id: u.id)
end

#add project type
["New","Enhancement","Maintance"].each do |pt|
ProjectType.create(project_name:"#{pt}", active: 1, user_id: u.id)
end



#Add super admin Role
s = SprintStatus.create(status: "true", active: 1, user_id: 1)

