class User < ActiveRecord::Base

  default_scope { order('created_at DESC') }


  paginates_per $PER_PAGE
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
           :omniauthable
  include DeviseTokenAuth::Concerns::User
 
    validates :email, :name, :branch_id, :company_id, :role_master_id, presence: true
    belongs_to :company
    belongs_to :role_master
    belongs_to :branch
    belongs_to :team_master
    after_create :send_welcome_email


    has_attached_file :avatar,
                   styles: {
                     medium: '300x300>',
                     thumb: '100x100>'
                   }                    

 validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\Z}
 validates_with AttachmentSizeValidator, attributes: :avatar,
                                         less_than: 2.megabytes

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

def getadmin_acccess(act_id)
  sub = []
  
  @sub_activity = ActivityMaster.where("parent_id=#{act_id}") 
  if @sub_activity != nil and @sub_activity.size.to_i!=0
        @sub_activity.each do |a|
        sub <<  {
          'menu' =>a.activity_Name,
          'href'  =>  a.href,
          'icon' => a.icon
        }
      end  
  end
  sub
end

def getstatus(act_id)
@sub_activity_true = ActivityMaster.where("parent_id=#{act_id}") 
  if @sub_activity_true != nil and @sub_activity_true.size.to_i!=0
  @val = true
  else
  @val = false
  end
end

def getaccess
  resp = []
  @access_value = User.find(id).role_master.role_activity_mappings
    @access_value.each do |access|      
    	@activity = ActivityMaster.find(access.activity_master_id)
      if @activity.parent_id.to_i == 0
      resp << {
           'main_menu' => @activity.activity_Name,
           'href'  =>  @activity.href,
           'icon' => @activity.icon,
           'sub_menu_status' => getstatus(access.activity_master_id),
           'sub_menu' => getadmin_acccess(access.activity_master_id) 
      }
    end
  end
  resp
end

def send_welcome_email
  #@user_welcome = User.find(id)
  #puts"--@user_welcome----#{email}---#{password}----#{name}--"
  UserNotifier.welcome_email(email,name,password).deliver_now
end#def send_welcome_email

end
