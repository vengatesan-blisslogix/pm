class ReleasePlanning < ActiveRecord::Base

  default_scope { order('created_at DESC') }


	paginates_per $PER_PAGE
	
	belongs_to :project_master
    validates :release_name, presence: true, uniqueness: true
	
end
