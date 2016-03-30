class RoleMaster < ActiveRecord::Base


   max_paginates_per 100
   default_scope { where(active: 1) } #only return the active roles
   has_many :users
   has_many :role_activity_mappings
   validates :role_name, :description, presence: true, uniqueness: true
end
