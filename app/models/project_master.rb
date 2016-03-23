class ProjectMaster < ActiveRecord::Base
   validates :project_name, presence: true, uniqueness: true
   validates :client_id, :start_date, :end_date , presence: true
   max_paginates_per 100
   #default_scope { where(active: 1) } #only return the active
end
