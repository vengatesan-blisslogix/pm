class ProjectUser < ActiveRecord::Base

  #default_scope { order('created_at DESC') }

	belongs_to :project_master
    belongs_to :user
	
	paginates_per $PER_PAGE
end
