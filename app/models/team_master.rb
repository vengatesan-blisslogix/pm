class TeamMaster < ActiveRecord::Base

  #default_scope { order('id DESC') }
	
  has_many :users
  validates :team_name, presence: true, uniqueness: true

       paginates_per $PER_PAGE

end
