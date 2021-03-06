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
r = RoleMaster.create(role_name: "Super Admin", active: "active")
#Add branch 
b = Branch.create(name: 'Chennai', active:"active")
#Add company
c = Company.create(company_name: 'TVS Next',
	            email: 'pmo@tvsnext.io',                
                mobile: '+91 44 49098874',
                active: 'active'               
                )
c.save!
#add super admin
u = User.create(email: 'pmo@tvsnext.io',
                name: 'Admin',                
                password: 'password',
                password_confirmation: 'password',
                active: 'active',
                branch_id: b.id,
                company_id: c.id,
                role_master_id: r.id,
                employee_no: 'NXT0001'
                )
u.save!




href = ["home.dashboard", "home.clients", "home.projects", "home.projectform", "home.projectMembers", "home.projectplan",  "home.taskBoard", "home.timesheet", "home.reports", "home.admin", "home.masters"]

icon = ["fa fa-fw fa-windows", "fa fa-fw fa-bullseye", "fa fa-fw fa-tachometer", "fa fa-file-word-o", "fa fa-fw fa-users", "fa fa-fw fa-plus-circle", "fa fa-fw fa-paper-plane", "fa fa-fw fa-plus-circle", "fa fa-fw fa-plus-circle", "fa fa-fw fa-plus-circle", "fa fa-fw fa-plus-circle"]
i = 0

["Dashboard", "Clients", "Projects", "Project Form","Project Members", "Project Plan", "Task Board", "Timesheet", "Reports", "Admin", "Masters"].each do |al|
a = ActivityMaster.create(activity_Name: "#{al}", active: "active", is_page: "yes", parent_id:0, href: href[i],  icon: icon[i])
RoleActivityMapping.create(role_master_id: r.id, activity_master_id: a.id, access_value: 1, user_id: u.id, active: 1)
i = i+1
end



#Add Project Plan sub activity
plan = ActivityMaster.find_by_activity_Name("Project Plan")
href = ["home.releasePlanning", "home.sprintPlanning", "home.productBacklog"]
icon = ["fa fa-fw fa-life-ring", "fa fa-fw fa-leaf", "fa fa-fw fa-arrows"]
i = 0
["Release Planning", "Sprint Planning", "Product Backlog"].each do |pp|
pn = ActivityMaster.create(activity_Name: "#{pp}", active: "active", is_page: "yes", parent_id: plan.id, href: href[i],  icon: icon[i])
RoleActivityMapping.create(role_master_id: r.id, activity_master_id: pn.id, access_value: 1, user_id: u.id, active: 1)
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
rep = ActivityMaster.create(activity_Name: "#{re}", active: "active", is_page: "yes", parent_id: report.id, href: href[i],  icon: icon[i])
RoleActivityMapping.create(role_master_id: r.id, activity_master_id: rep.id, access_value: 1, user_id: u.id, active: 1)
i = i+1
end



#add admin sub activity
href = ["home.users", "home.roles", "home.activity","home.branch","home.technology","home.team","home.holidays"]

icon = ["fa fa-fw fa-user", "fa fa-fw fa-shield", "fa fa-fw fa-check-square", "fa fa-fw fa-code-fork", "fa fa-fw fa-laptop", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer"]
i = 0
admin = ActivityMaster.find_by_activity_Name("Admin")
["Users","Roles","Activity","Branch","Technology","Team", "Holidays"].each do |ad|
ad = ActivityMaster.create(activity_Name: "#{ad}", active: "active",  is_page: "yes", parent_id: admin.id, href: href[i],  icon: icon[i])
RoleActivityMapping.create(role_master_id: r.id, activity_master_id: ad.id, access_value: 1, user_id: u.id, active: 1)
i = i+1
end

#add timesheet sub activity
    href = ["home.timesheets", "home.timesheetsSummary" ]
    icon = ["fa fa-fw fa-tachometer","fa fa-fw fa-tachometer"]
    i = 0
    admin = ActivityMaster.find_by_activity_Name("Timesheet")
    ["Timesheets","Timesheet Summary" ].each do |ad|
    ad = ActivityMaster.create(activity_Name: "#{ad}", active: "active",  is_page: "yes", parent_id: admin.id, href: href[i],  icon: icon[i])
    RoleActivityMapping.create(role_master_id: 1, activity_master_id: ad.id, access_value: 1, user_id: 1, active: 1)
    i = i+1
    end  

#add master sub activity
href = ["home.project_domains","home.project_status_masters","home.task_status_master", "home.business_units","home.project_locations","home.engagement_types", "home.project_payments", "home.checklist"]

icon = ["fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer"]
i = 0
admin = ActivityMaster.find_by_activity_Name("Masters")
["ProjectDomains", "ProjectStatus", "TaskStatus", "Business Units", "Project Locations", "Engagement Types", "Project Payment", "Checklist"].each do |ad|
ad = ActivityMaster.create(activity_Name: "#{ad}", active: "active",  is_page: "yes", parent_id: admin.id, href: href[i],  icon: icon[i])
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



#add Activities
["Create New Client",
"Edit Client",
"Create New Project",
"Edit Project",
"Create Project Members",
"Edit Project Members",
"Create Release Plan",
"Edit Releaseplan",
"Create Sprint Plan",
"Edit Sprint Plan",
"Create Product Backlog",
"Edit Product Backlog",
"Add Unassigned task",
"Create New User",
"Edit User",
"Create New Role",
"Edit Role",
"Create New Activity",
"Edit Activity",
"Create New Branch",
"Edit Branch",
"Create New Technology",
"Edit Technology",
"Create New Team",
"Edit Team",
"Create New Holiday",
"Edit Holiday"].each do |act|
act = ActivityMaster.create(activity_Name: "#{act}", active: "active",  is_page: "no")
end
