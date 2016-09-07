class Api::V1::ChecklistRejectsController < ApplicationController


before_action :authenticate_user!
before_action :set_checklist_rejects, only: [:show, :edit, :update]

def index
#search
        if params[:search]!=nil and params[:search]!=""
          @search ="id = #{params[:search]}"
        else
          @search =""
        end
        #search

    @checklist_rejects = ChecklistReject.where("#{@search}").page(params[:page]).order(:created_at => 'desc')
    resp=[]
     @checklist_rejects.each do |clr| 
      resp << {
        'id' => clr.id,
        'stage_name' => clr.stage_name,
        'reason' => clr.reason,
        'user_id' => clr.user_id,
        'checklist_id' => clr.checklist_id,
        'taskboard_id' => clr.taskboard_id,
        'date' => clr.date
      }
      end

    pagination(ChecklistReject,@search)
    get_all_checklist_rejects
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'checklist_reject_list' => @checklist_reject_resp,
      'checklist_reject_resp' => resp

    }
  render json: response
 
end

def show
   render json: @checklist_reject
end

def create

    @checklist_reject = ChecklistReject.new(checklist_reject_params)
    if @checklist_reject.save            
    	render json: { valid: true, msg:"checklist moved successfully."}  
      #index
    else
      render json: { valid: false, error: @checklist_reject.errors }, status: 404
    end    
  end

 def update   

    if @checklist_reject.update(checklist_reject_params)  	      
       render json: { valid: true, msg:"checklist moved successfully"}
    else
        render json: { valid: false, error: @checklist_reject.errors }, status: 404
    end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_checklist_rejects
      @checklist_reject = ChecklistReject.find_by_id(params[:id])
      if @checklist_reject
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def checklist_reject_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :stage_name => "#{params[:stage_name]}", :reason => "#{params[:reason]}", :user_id => "#{params[:user_id]}", :checklist_id => "#{params[:checklist_id]}", :taskboard_id => "#{params[:taskboard_id]}", :date => "#{params[:date]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:stage_name, :reason, :user_id, :checklist_id, :taskboard_id, :date)
    
    end

end
