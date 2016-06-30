class RoleMaster < ActiveRecord::Base

  #default_scope { order('created_at DESC') }

   #max_paginates_per 10
   paginates_per $PER_PAGE
   #default_scope { where(active: 1) } #only return the active roles
   has_many :users
   has_many :role_activity_mappings
   validates :role_name, presence: true, uniqueness: true
end
