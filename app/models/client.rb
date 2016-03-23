class Client < ActiveRecord::Base
   validates :client_name,:client_email, presence: true, uniqueness: true
   validates :mobile, :client_source_id, presence: true
   max_paginates_per 100
   #default_scope { where(active: 1) } #only return the active
end
