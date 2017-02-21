class Logtime < ActiveRecord::Base
   #paginates_per $PER_PAGE
  
  default_scope { where(is_delete: 0) }


end
