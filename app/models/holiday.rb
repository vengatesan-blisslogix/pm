class Holiday < ActiveRecord::Base

     paginates_per $PER_PAGE

   validates :date, presence: true, uniqueness: true


end
