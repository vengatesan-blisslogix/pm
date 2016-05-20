class Taskboard < ActiveRecord::Base
	
default_scope { order('created_at DESC') }
	
	belongs_to :project_master
    paginates_per $PER_PAGE

    validates_presence_of :project_master_id

end
