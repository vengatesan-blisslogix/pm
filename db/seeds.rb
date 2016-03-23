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
["Add Role", "Add Company", "Add Clients", "Add Clients Source", "Add Users", "Add Activity", "Add Branch", "Add Project", "Add Project User", "Add Release Planning", "Add Sprint Planning", "Add Project Task", "Add Task Status Master", "Add Project Status Master", "Add Project Timesheet"].each do |am|
 a = ActivityMaster.create(activity_Name: "#{am}", active: 1)
 RoleActivityMapping.create(role_master_id: r.id, activity_master_id: a.id, access_value: 1, user_id: u.id, active: 1)
end


