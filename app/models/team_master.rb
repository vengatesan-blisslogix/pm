class TeamMaster < ActiveRecord::Base

  default_scope { order('created_at DESC') }
	
  has_many :users
  validates :team_name, presence: true, uniqueness: true
end
