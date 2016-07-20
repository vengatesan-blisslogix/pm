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
        'name' => cl.name,
        'active' => cl.active,
        'description' => cl.description,
        'stage' => cl.stage,
        'stage_value' => cl.stage_value
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
   render json: @checklist
end

def create

    @checklist = Checklist.new(checklist_params)
    if @checklist.save
            @checklist.active = "active"
        @checklist.save
    	render json: { valid: true, msg:"#{@checklist.name} created successfully."}  
      #index
    else
      render json: { valid: false, error: @checklist.errors }, status: 404
    end    
  end

 def update   

    if @checklist.update(checklist_params)  	      
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
      parameters.permit(:name, :active, :description, :user_id, :stage, :stage_value)
    
    end

end