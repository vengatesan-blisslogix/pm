class ProjectStatusMaster < ActiveRecord::Base

  default_scope { order('created_at DESC') }

     paginates_per $PER_PAGE


end
