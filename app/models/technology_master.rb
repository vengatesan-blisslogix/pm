class TechnologyMaster < ActiveRecord::Base

  default_scope { order('id DESC') }

  validates :technology, presence: true, uniqueness: true

    paginates_per $PER_PAGE
	
end
