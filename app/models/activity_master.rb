class ActivityMaster < ActiveRecord::Base

  default_scope { order('id ASC') }

     paginates_per $PER_PAGE

	
end
