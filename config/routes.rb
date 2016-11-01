Rails.application.routes.draw do

 #get 'home/index'

  root 'home#index'
scope :api do
  scope :v1 do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'api/v1/overrides/registrations'
    }
  end
end

match "/api/v1/forget_password", :to => "home#forget_password", :via => ["post"]

match "/api/v1/add_edit_user", :to => "home#add_edit_user", :via => ["get"]
match "/api/v1/add_new_client", :to => "home#add_new_client", :via => ["get"]
match "/api/v1/add_new_project", :to => "home#add_new_project", :via => ["get"]
match "/api/v1/get_sprint", :to => "home#get_sprint", :via => ["get"]
match "/api/v1/get_task_project", :to => "home#get_task_project", :via => ["get"]
match "/api/v1/get_release", :to => "home#get_release", :via => ["get"]
match "/api/v1/add_sprint", :to => "home#add_sprint", :via => ["get"]
match "/api/v1/add_taskboard", :to => "home#add_taskboard", :via => ["get"]
match "/api/v1/get_project_users", :to => "home#get_project_users", :via => ["get"]
match "/api/v1/filter_project_user", :to => "home#filter_project_user", :via => ["get"]
match "/api/v1/get_client_project", :to => "home#get_client_project", :via => ["get"]
match "/api/v1/all_projects", :to => "home#all_projects", :via => ["get"]
match "/api/v1/get_release_sprint", :to => "home#get_release_sprint", :via => ["get"]
match "/api/v1/get_sprint_task", :to => "home#get_sprint_task", :via => ["get"]
match "/api/v1/get_manager", :to => "home#get_manager", :via => ["get"]
match "/api/v1/get_user", :to => "home#get_user", :via => ["get"]
match "/api/v1/add_menus", :to => "home#add_menus", :via => ["get"]
match "/api/v1/get_role_email", :to => "home#get_role_email", :via => ["get"]



match "/api/v1/user_tech", :to => "home#user_tech", :via => ["get"]
match "/api/v1/get_task_user", :to => "home#get_task_user", :via => ["get"]
match "/api/v1/get_task_status", :to => "home#get_task_status", :via => ["get"]
match "/api/v1/show_checklist", :to => "home#show_checklist", :via => ["get"]
match "/api/v1/task_completed", :to => "home#task_completed", :via => ["get"]
match "/api/v1/log_hours", :to => "home#log_hours", :via => ["get"]
match "/api/v1/role_mapping/:id", :to => "home#role_mapping", :via => ["get"]
match "/api/v1/user_profile/:id", :to => "home#user_profile", :via => ["put"]
match "/api/v1/view_user_profile/:id", :to => "home#view_user_profile", :via => ["get"]


match "/api/v1/utilization_report", :to => "home#utilization_report", :via => ["get"]
match "/api/v1/report_1", :to => "home#report_1", :via => ["get"]
match "/api/v1/report_2", :to => "home#report_2", :via => ["get"]
match "/api/v1/report_3", :to => "home#report_3", :via => ["get"]
match "/api/v1/report_4", :to => "home#report_4", :via => ["get"]
match "/api/v1/report_5", :to => "home#report_5", :via => ["get"]


match "/api/v1/timesheet_summary", :to => "home#timesheet_summary", :via => ["get"]
match "/api/v1/edit_summary", :to => "home#edit_summary", :via => ["get"]
match "/api/v1/past_summary", :to => "home#past_summary", :via => ["post"]
match "/api/v1/add_timesheets", :to => "home#add_timesheets", :via => ["post"]
match "/api/v1/timesheet_approval/:id", :to => "home#timesheet_approval", :via => ["post"]

match "/api/v1/user_eldap", :to => "home#user_eldap", :via => ["post"]

match "/api/v1/manager_master", :to => "home#manager_master", :via => ["get"]
match "/api/v1/employee_master", :to => "home#employee_master", :via => ["get"]

match "/api/v1/search_user", :to => "home#search_user", :via => ["post"]



resources :home
  #mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api do
   namespace :v1 do


      resources :role_masters
      resources :branches
      resources :users
      resources :companies
      resources :team_masters
      resources :technology_masters
      resources :clients
      resources :client_sources
      resources :project_masters
      resources :user_technologies
      resources :release_plannings
      resources :sprint_plannings
      resources :project_tasks
      resources :project_task_mappings
      resources :project_time_sheets
      resources :activity_masters
      resources :todotasklists
      resources :todotaskshares
      resources :todotaskmappings
      resources :project_users
      resources :taskboards
      resources :task_status_masters
      resources :timesheets
      resources :assigns
      resources :timelogs
      resources :percentages
      resources :holidays
      resources :project_status_masters
      resources :project_domains
      resources :billable_types
      resources :business_units
      resources :project_locations
      resources :engagement_types
      resources :project_payments
      resources :checklists
      resources :checklist_rejects


   end#namespace :v1 do
  end#namespace :api do

  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
