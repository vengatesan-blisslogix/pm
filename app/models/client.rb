class Client < ActiveRecord::Base

  #default_scope { order('created_at DESC') }


   #validates :client_name, :client_email, presence: true, uniqueness: true
   #validates :mobile, :client_source_id, presence: true
   #max_paginates_per 100
   paginates_per $PER_PAGE
   #default_scope { where(active: 1) } #only return the active
end
