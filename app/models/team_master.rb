class TeamMaster < ActiveRecord::Base
  has_many :users
  validates :team_name, presence: true, uniqueness: true
end
