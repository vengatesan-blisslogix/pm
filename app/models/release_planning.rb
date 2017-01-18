class ReleasePlanning < ActiveRecord::Base

  #default_scope { order('created_at DESC') }


	#paginates_per $PER_PAGE
	
	belongs_to :project_master
    validates :release_name, presence: true

    validates :release_name, uniqueness: { scope: [:project_master_id] }

end
