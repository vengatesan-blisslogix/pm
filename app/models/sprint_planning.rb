class SprintPlanning < ActiveRecord::Base

 # default_scope { order('created_at DESC') }

  paginates_per $PER_PAGE

  validates :sprint_name, presence: true, uniqueness: true

end
