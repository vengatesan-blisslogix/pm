class ProjectRequestForm < ActiveRecord::Base

  has_attached_file :signed_copy, styles: {  }, default_url: "/images/:style/missing.png"
  has_attached_file :mail_approval, styles: { }, default_url: "/images/:style/missing.png"
    paginates_per $PER_PAGE
    

    validates_attachment_content_type :signed_copy, :content_type  => [ 
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
    validates_attachment_content_type :mail_approval, :content_type  => [ 
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
    validates_with AttachmentSizeValidator, attributes: :signed_copy,
                                         less_than: 2.megabytes

    validates_with AttachmentSizeValidator, attributes: :mail_approval,
                                         less_than: 2.megabytes


end

