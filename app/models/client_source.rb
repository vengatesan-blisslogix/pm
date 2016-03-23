class ClientSource < ActiveRecord::Base
   
   validates :source_name, presence: true, uniqueness: true
   max_paginates_per 100
   #default_scope { where(active: 1) } #only return the active
end
