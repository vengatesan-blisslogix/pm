class Taskboard < ActiveRecord::Base
	
default_scope { order('created_at DESC') }
	
	belongs_to :project_master
    paginates_per $PER_PAGE


end
