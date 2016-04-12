class ProjectUser < ActiveRecord::Base
	belongs_to :project_master
	paginates_per $PER_PAGE
end
