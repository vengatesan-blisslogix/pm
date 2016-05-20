class ActivityMaster < ActiveRecord::Base

  default_scope { order('created_at DESC') }
	
end
