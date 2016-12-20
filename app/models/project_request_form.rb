class ProjectRequestForm < ActiveRecord::Base

	has_attached_file :signed_copy, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  	has_attached_file :mail_approval, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
    
    validates_attachment_content_type :signed_copy, content_type: /\Aimage\/.*\Z/
  	validates_attachment_content_type :mail_approval, content_type: /\Aimage\/.*\Z/	
  	validates_with AttachmentSizeValidator, attributes: :signed_copy,
                                         less_than: 2.megabytes

validates_with AttachmentSizeValidator, attributes: :mail_approval,
                                         less_than: 2.megabytes

end
