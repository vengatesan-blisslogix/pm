class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

# protect_from_forgery with: :exception

 #protect_from_forgery with: :null_session

 $PER_PAGE = 10 #per page records
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
        :nickname
        
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
          'id' => a.id,
          'assigne' => a.assigned_user_id,
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
    @total_time <<  ((l.end_time - l.start_time) / 1.hour).round
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
    end
    if @prev == nil
    @prev = false
    end
    if @next == nil
    @next = false
    end

   def get_all_projects
      @project_all = ProjectMaster.all.order(:id)
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
      @release_all = ReleasePlanning.where("project_master_id = #{params[:project_master_id]}").order(:id)
       
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
      @release_all = ReleasePlanning.where("project_master_id = #{params[:project_master_id]}").order(:id)
      
      @release_all.each do |p| 
        @project_sprint_resp << {
         'id' => p.id,
         'release_name' => p.release_name      
        }
        end
      end
   end

   def get_all_sprint_status
        @sprint_status_all = SprintStatus.all.order(:id)
        @sprint_status_resp=[]
        @sprint_status_all.each do |s| 
           @sprint_status_resp << {
          'id' => s.id,
          'sprint_status' => s.status      
        }
        end
    end

    def get_all_clients
        @client_all = Client.all.order(:id)
        @client_resp=[]
        @client_all.each do |c| 
           @client_resp << {
          'id' => c.id,
          'client_name' => c.client_name      
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
