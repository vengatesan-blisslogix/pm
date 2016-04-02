class HomeController < ApplicationController
  def index
  end


  def forget_password

     user = User.find_by(email: params[:email]) 
   
	if user
		success=1
		if params[:email] && params[:otp] && params[:password]
			 if user.otp!=nil and user.otp==params[:otp].to_i
			   user.update_attribute(:password,params[:password])            
			   user.otp = nil
			   user.save
			   success=1          
			 else
			  success=0           
			 end 
		end#if params[:email] && params[:otp]

		if params[:password_reset] && params[:password_reset].to_i==1
		 @r = rand(9999).to_s.center(4, rand(3).to_s).to_i
		 user.update_attribute(:otp,@r)  
		 UserNotifier.forget_password_otp_send(user).deliver_now                 
		 success=1
		end#if params[:password_reset]      

	else#if user       
		success=0
	end#if user

if success==1
render json: { valid: true}, status: 200
else
render json: { valid: false, error:"404"}, status: 200
end

   end#def validate_user



def add_edit_user
      resp = []
      resp << {
        'company' => getcompany,
        'role' => getrole,
        'branch' => getbranch,
        'reporting_to' => getreporting_to,
        'team' => getteam,
        'technology' => gettech      
      }
     
    render json: resp
end
def add_new_client
    resp = []
    @client_sources = ClientSource.all.order(:id)
    @client_sources.each do |cs|
      resp << {
        'id' => cs.id,
        'client_source_name' => cs.source_name
              
      }
     end

     client_source = []
     client_source << {
      'source' => resp
     }
    render json: client_source
  end

def add_new_project
      resp = []
      resp << {
        'project_type' => getproject_type,
        'domain_name' => getdomain_name,
        'client_name' => getclient_name,
        'project_status' => getproject_status
            
      }
     
    render json: resp
end

private

def getcompany
  resp = []
    @value = Company.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'company_name' => v.company_name
      }
    end
    resp
end

def getrole
  resp = []
    @value = RoleMaster.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'role_name' => v.role_name
      }
    end
    resp
end

def getbranch
  resp = []
    @value = Branch.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'branch_name' => v.name
      }
    end
    resp
end

def getreporting_to
  resp = []
    @value = User.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'reporting_name' => v.name
      }
    end
    resp
end

def getteam
  resp = []
    @value = TeamMaster.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'team_name' => v.team_name
      }
    end
    resp
end

def gettech
  resp = []
    @value = TechnologyMaster.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'technology_name' => v.technology
      }
    end
    resp
end

def getproject_type
  resp = []
    @value = ProjectType.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'project_type_name' => v.project_name
      }
    end
    resp
end

def getdomain_name
  resp = []
    @value = ProjectDomain.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'domain_name' => v.domain_name
      }
    end
    resp
end

def getclient_name
  resp = []
    @value = Client.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'client_name' => v.client_name
      }
    end
    resp
end

def getproject_status
  resp = []
    @value = ProjectStatusMaster.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'project_status' => v.status
      }
    end
    resp
end




end