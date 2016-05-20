class Company < ActiveRecord::Base

  default_scope { order('created_at DESC') }
	
  has_many :users
end
