class ProjectTask < ActiveRecord::Base



	default_scope { where(active: "active", is_delete: 1)}
	
	belongs_to :project_master
    
    validates_presence_of :project_master_id

	#paginates_per $PER_PAGE

end
