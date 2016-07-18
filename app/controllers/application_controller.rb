class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

# protect_from_forgery with: :exception

 #protect_from_forgery with: :null_session

 $PER_PAGE = 20 #per page records
 before_action :configure_permitted_parameters, if: :devise_controller?
  
  private

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << [
        :mobile_no,
        :office_phone,
        :home_phone,
        :profile_photo,
        :active,
        :branch_id,
        :company_id,
        :role_master_id,
        :name,     
        :password,
        :team_id,
        :prior_experience,
        :doj,
        :dob,
        :avatar,
        :last_name,
        :created_by_user,
        :reporting_to,
        :nickname,
        :employee_no        
      ]
    end


  def get_assigne(task_master_id, stage)
puts "-----------------#{task_master_id}----#{stage}-------------------"

    @assigned = []
         @assigne = Taskboard.where("#{stage} = ? and task_master_id = #{task_master_id}", true).first
         if @assigne!=nil
         @find_assigne =  Assign.where("taskboard_id=#{@assigne.id}")

         @find_assigne.each do |a|
          puts"-============ @find_assigne @find_assigne---#{a.id}---#{@find_assigne}"   

          @assigned << {
          'assign_id' => a.id,#id
          'id' => a.assigned_user_id,#assignee_user_id
          'assigned' => true
          }         
       end
     end
  end

  def get_hours(task_master_id)
    @hours_resp =  []
    @logtimes = Logtime.where("task_master_id = #{task_master_id}")
    @total_time =  [] 

    @logtimes.each do |l|  
      if l.end_time!=nil and l.start_time!=nil
    @total_time <<  ((l.end_time - l.start_time) / 1.hour).round
  end
    end
puts "-----------#{@total_time}-----------"
    @hours_resp << {
        'total_hours' => @total_time.sum
      }

  end


    def get_task_board(project_master_id)
    @project_users_resp = []
      #@project_task.project_master_id != nil
       if project_master_id != nil
        @project_users = ProjectUser.where("project_master_id = #{project_master_id}")
        
        @project_users.each do |pu|  
          puts "********#{pu.user_id}******"
          @project_names = User.find_by_id(pu.user_id)
        @project_users_resp << {
          'id' => @project_names.id,
          'username' => @project_names.name
        }
        end

        @taskboard = Taskboard.where("project_master_id = #{project_master_id}")
        @project_task_resp = []
        @taskboard.each do |tb| 
         @task_users = ProjectTask.find_by_id(tb.task_master_id)

         @project_task_resp << {
          'id' => tb.id,
          'task_name' => @task_users.task_name
        }
        end
      end#@project_task.project_master_id != nil      
    end


    def current_user
      if params[:user_id]
      current_user = User.find_by_id(params[:user_id])
      else
      render json: { valid: false, error: 'unauthorized user!!!' }, status: 404
      end
    end
  
    def pagination(model,search)
    @no_of_records = model.where("#{search}").all
    @no_of_pages = @no_of_records.size.to_i.divmod($PER_PAGE.to_i)
        @no_pages = @no_of_pages[0].to_i
        if @no_of_pages[1].to_i!=0
        @no_pages = @no_pages+1
        end
        if params[:page]!=nil and params[:page]!="" and params[:page].to_i!=0
        current_page = params[:page].to_i
        else
        current_page = 1
        end

    if @no_pages.to_i > 1 && current_page == 1
      @prev = false
      @next = "page=#{current_page+1}"
    end
    if @no_pages.to_i > 1 && current_page == @no_pages.to_i
       @prev = "page=#{current_page-1}"
       @next = false
    end
    if @no_pages.to_i > 1 && current_page != 1 && current_page != @no_pages.to_i
      @prev = "page=#{current_page-1}"
      @next = "page=#{current_page+1}"
    end
   
    if @prev == nil
    @prev = false
    end
    if @next == nil
    @next = false
    end
 end
 
   def get_all_projects
  
if current_user.role_master_id==1
@search_all_pro=""
@search_all_pro_id=""
else
  @find_pro = ProjectUser.where("user_id=#{current_user.id}").select(:project_master_id).uniq
  @search_all_pro_id=""
  @find_pro.each do |fp|
  if @search_all_pro_id==""
    @search_all_pro_id=fp.project_master_id
  else
    @search_all_pro_id=@search_all_pro_id.to_s+","+fp.project_master_id.to_s
  end
  end
  if @search_all_pro_id==""
    @search_all_pro="id IN(0)"
  else
    @search_all_pro="id IN(#{@search_all_pro_id})"
  end

end
      @project_all = ProjectMaster.where("#{@search_all_pro}").order(:project_name)
      @project_resp=[]
      @project_all.each do |p| 
        @project_resp << {
         'id' => p.id,
         'project_name' => p.project_name      
        }
      end
   end

   def get_all_releases(project_master_id)
     @release_resp=[]
     if project_master_id != nil && project_master_id != ""
      @release_all = ReleasePlanning.where("project_master_id = #{params[:project_master_id]}").order(:release_name)
       
      @release_all.each do |p| 
        @release_resp << {
         'id' => p.id,
         'release_name' => p.release_name,
         'start_date' => p.start_date,
         'end_date' => p.end_date,
         'release_notes' => p.release_notes,
         'active' => p.active
        }
        end
      end
   end


   def get_project_sprint(project_master_id)
     @project_sprint_resp=[]
     if project_master_id != nil && project_master_id != ""
      @release_all = ReleasePlanning.where("project_master_id = #{params[:project_master_id]}").order(:release_name)
      
      @release_all.each do |p| 
        @project_sprint_resp << {
         'id' => p.id,
         'release_name' => p.release_name      
        }
        end
      end
   end

   def get_all_sprint_status
        @sprint_status_all = SprintStatus.all.order(:status)
        @sprint_status_resp=[]
        @sprint_status_all.each do |s| 
           @sprint_status_resp << {
          'id' => s.id,
          'sprint_status' => s.status      
        }
        end
    end

    def get_all_clients
        @client_all = Client.all.order(:client_name)
        @client_resp=[]
        @client_all.each do |c| 
           @client_resp << {
          'id' => c.id,
          'client_name' => c.client_name      
        }
        end
    end 

      def get_all_role
        @role_all = RoleMaster.all.order(:role_name)
        @role_resp=[]
        @role_all.each do |rm| 
           @role_resp << {
          'id' => rm.id,
          'role_name' => rm.role_name       
        }
        end
    end   

      def get_all_activity
        @activity_all = ActivityMaster.all.order(:activity_Name)
        @activity_resp=[]
        @activity_all.each do |am| 
           @activity_resp << {
          'id' => am.id,
          'activity_name' => am.activity_Name       
        }
        end
    end    

      def get_all_technology
        @technology_all = TechnologyMaster.all.order(:technology)
        @technology_resp=[]
        @technology_all.each do |tm| 
           @technology_resp << {
          'id' => tm.id,
          'technology_name' => tm.technology      
        }
        end
    end   

      def get_all_team
        @team_all = TeamMaster.all.order(:team_name)
        @team_resp=[]
        @team_all.each do |t| 
           @team_resp << {
          'id' => t.id,
          'team_name' => t.team_name      
        }
        end
    end   

    def get_all_holiday
        @holiday_all = Holiday.all.order(:date)
        @holiday_resp=[]
        @holiday_all.each do |h| 
           @holiday_resp << {
          'id' => h.id,
          'holiday_date' => h.date.strftime("%m/%d/%Y")   
        }
        end
    end   

      def get_all_branch
        @branch_all = Branch.all.order(:name)
        @branch_resp=[]
        @branch_all.each do |b| 
           @branch_resp << {
          'id' => b.id,
          'branch_name' => b.name      
        }
        end
    end   

    def get_all_domain
        @domain_all = ProjectDomain.all.order(:domain_name)
        @domain_resp=[]
        @domain_all.each do |d| 
           @domain_resp << {
          'id' => d.id,
          'branch_name' => d.domain_name      
        }
        end
    end       

    def get_all_business
        @business_all = BusinessUnit.all.order(:name)
        @business_resp=[]
        @business_all.each do |bu| 
           @business_resp << {
          'id' => bu.id,
          'business_name' => bu.name      
        }
        end
    end    

    def get_all_location
        @location_all = ProjectLocation.all.order(:name)
        @location_resp=[]
        @location_all.each do |pl| 
           @location_resp << {
          'id' => pl.id,
          'location_name' => pl.name      
        }
      end
    end

    def get_all_engagement
        @engagement_all = EngagementType.all.order(:name)
        @engagement_resp=[]
        @engagement_all.each do |et| 
           @engagement_resp << {
          'id' => et.id,
          'location_name' => et.name      
        }
      end
    end

    def get_all_payment
        @payment_all = ProjectPayment.all.order(:name)
        @payment_resp=[]
        @payment_all.each do |pp| 
           @payment_resp << {
          'id' => pp.id,
          'location_name' => pp.name      
        }
      end
    end

    def convert_param_to_array(value)
    value = value.gsub('"',"")
    @output_array = []
    value.split(",").each do |user|
    @output_array << user
    end
    end
    
end
