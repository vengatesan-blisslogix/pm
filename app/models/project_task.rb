class ProjectTask < ActiveRecord::Base



default_scope { order('created_at DESC')}, 
default_scope { where(active: "active")}
	
	belongs_to :project_master
    
    validates_presence_of :project_master_id

	paginates_per $PER_PAGE

end
