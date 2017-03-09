class Api::V1::ChecklistsController < ApplicationController

before_action :authenticate_user!
before_action :set_checklists, only: [:show, :edit, :update]

def index
#search
        if params[:search]!=nil and params[:search]!=""
          @search ="id = #{params[:search]}"
        else
          @search =""
        end
        #search

    @checklists = Checklist.where("#{@search}").page(params[:page]).order(:created_at => 'desc')
    resp=[]
     @checklists.each do |cl| 
      resp << {
        'id' => cl.id,
        'checklist_name' => cl.name,
        'active' => cl.active,
        'description' => cl.description,
        'project_board_status' => cl.stage,
        'project_board_id' => cl.stage_value
      }
      end

    pagination(Checklist,@search)
    get_all_checklist
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'checklist_list' => @checklist_resp,
      'checklist_resp' => resp

    }
  render json: response
 
end

def show	
  c = @checklist
   resp=[]
      resp << {
        'id' => c.id,
        'checklist_name' => c.name,
        'active' => c.active,
        'description' => c.description,
        'project_board_status' => c.stage,
        'project_board_id' => c.stage_value
      }
      
         render json: resp

end

def create

    @checklist = Checklist.new(checklist_params)
    if @checklist.save
            @checklist.active = "active"
            @checklist.stage = params[:project_board_status]
            @checklist.stage_value = params[:project_board_id]
        @checklist.save
    	render json: { valid: true, msg:"#{@checklist.name} created successfully."}  
      #index
    else
      render json: { valid: false, error: @checklist.errors }, status: 404
    end    
  end

 def update   

    if @checklist.update(checklist_params)  
            @checklist.stage = params[:project_board_status]
            @checklist.stage_value = params[:project_board_id]	
            @checklist.save      
       render json: { valid: true, msg:"#{@checklist.name} updated successfully."}
    else
        render json: { valid: false, error: @checklist.errors }, status: 404
    end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_checklists
      @checklist = Checklist.find_by_id(params[:id])
      if @checklist
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def checklist_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :name => "#{params[:name]}", :active => "#{params[:active]}", :user_id => "#{params[:user_id]}", :description => "#{params[:description]}", :stage => "#{params[:stage]}", :stage_value => "#{params[:stage_value]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:name, :active, :description, :user_id)
    
    end

end
