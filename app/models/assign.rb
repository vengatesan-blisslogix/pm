class Assign < ActiveRecord::Base
	  default_scope { where(is_delete: 0) }

end
