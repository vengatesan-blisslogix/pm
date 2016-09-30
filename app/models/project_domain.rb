class ProjectDomain < ActiveRecord::Base

  #default_scope { order('created_at DESC') }


   validates :domain_name, presence: true, uniqueness: true

   paginates_per $PER_PAGE
	
end
