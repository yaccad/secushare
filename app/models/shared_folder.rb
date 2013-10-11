class SharedFolder < ActiveRecord::Base  
  #attr_accessible :user_id, :shared_email, :shared_user_id,  :message,  :folder_id  
    
  #this is for the owner(creator) of the uploads  
  belongs_to :user  
    
  #this is for the user to whom the owner has shared folders to  
  belongs_to :shared_user, :class_name => "User", :foreign_key => "shared_user_id"  
    
  #for the folder being shared  
  belongs_to :folder  


  private

  def shared_folder_params
    params.require(:shared_folder).permit(:user_id, :shared_email, :shared_user_id,  :message,  :folder_id)
  end
 
end  