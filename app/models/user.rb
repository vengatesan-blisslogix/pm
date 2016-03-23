class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
           :omniauthable
  include DeviseTokenAuth::Concerns::User
 
    validates :email, :name, :branch_id, :company_id, :role_master_id, presence: true
    belongs_to :company
    belongs_to :role_master
    belongs_to :branch

 # Override default Devise serializer
  def token_validation_response
      serialize_self
  end
    def serialize_self
    {
      'status'=>'success',
      'id' => id,
      'provider' => provider,
      'uid' => uid,
      'email' => email,      
      'Name' => name,      
      'role' => getrole,
      'company' => getcompany,
      'branch' => getbranch,
      'access' => getaccess
    }
  end

  private
def getrole
	resp = []
	@role = RoleMaster.find(role_master_id)
	resp = @role.role_name if @role
end
def getcompany
	resp = []
	@comp = Company.find(company_id)
	resp = @comp.company_name if @comp
end
def getbranch
	resp = []
	@branch = Branch.find(branch_id)
	resp = @branch.name if @branch
end
  def getaccess
    resp = []
    @access_value = User.find(id).role_master.role_activity_mappings
    @access_value.each do |access|
    	@activity = ActivityMaster.find(access.activity_master_id)
      resp << {
        'id' => access.id,
        'action' => @activity.activity_Name,
        'access' => access.access_value
      }
    end
    resp
  end
end
