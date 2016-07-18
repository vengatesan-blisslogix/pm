class BusinessUnit < ActiveRecord::Base
   validates :name, presence: true, uniqueness: true
   paginates_per $PER_PAGE

end
