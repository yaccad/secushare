class Upload < ActiveRecord::Base

  belongs_to :user
  belongs_to :folder  
  include Rails.application.routes.url_helpers
  #set up "uploaded_file" field as attached_file (using Paperclip)  
  has_attached_file :uploaded_file,  
                 :url => "/uploads/get/:id",  
                 :path => "#{::Rails.root}/uploads/:id/:basename.:extension"  
   

  validates_attachment_size :uploaded_file, :less_than => 150.megabytes    
  validates_attachment_presence :uploaded_file
  
  def file_name
   uploaded_file_file_name
  end

  def file_size
   uploaded_file_file_size
  end
  
  def to_jq_upload
    {
      "name" => read_attribute(:uploaded_file_file_name),
      "size" => read_attribute(:uploaded_file_file_size),
      "url" => uploaded_file.url(:original),
      "delete_url" => upload_path(self),
      "delete_type" => "DELETE" 
    }
  end
  
end
