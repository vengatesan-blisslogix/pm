class Taskboard < ActiveRecord::Base
	
#default_scope { order('created_at DESC') }


default_scope { where(status: "active", task_complete: nil)}

	
	belongs_to :project_master
    paginates_per $PER_PAGE


end
