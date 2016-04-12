class ProjectMaster < ActiveRecord::Base
   validates :project_name, presence: true, uniqueness: true
   validates :client_id, :start_date, :end_date , presence: true
   #max_paginates_per 100
   paginates_per $PER_PAGE
   #default_scope { where(active: 1) } #only return the active
   has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
has_many :project_tasks
has_many :release_plannings

end
