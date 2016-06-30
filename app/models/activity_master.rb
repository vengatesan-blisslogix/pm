class ActivityMaster < ActiveRecord::Base

 # default_scope { order('created_at ASC') }

  validates :activity_Name, presence: true, uniqueness: true

     paginates_per $PER_PAGE

	
end
