class Branch < ActiveRecord::Base

  #default_scope { order('created_at DESC') }

   has_many :users
   validates :name, presence: true, uniqueness: true
   max_paginates_per 100
   #default_scope { where(active: 1) } #only return the active branch

end
