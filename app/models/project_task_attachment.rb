class ProjectTaskAttachment < ActiveRecord::Base
  has_attached_file :avatar, styles: {  }, default_url: "/images/:style/missing.png"
            

 validates_attachment_content_type :avatar, :content_type  => [ 
      /\Aimage\/.*\Z/, 
       "application/pdf", 
       "application/vnd.ms-excel", 
       "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", 
       "application/msword", 
       "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
       "application/vnd.ms-powerpoint", 
       "application/vnd.openxmlformats-officedocument.presentationml.presentation", 
       "application/zip",
       "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
       "text/plain"
    ]
 validates_with AttachmentSizeValidator, attributes: :avatar,
                                         less_than: 2.megabytes

end
