class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, :presence => true, :uniqueness => true
         
  has_many :uploads
  has_many :folders, :dependent => :destroy
  
  # this is for folders which the user has shared
   has_many :shared_folders, :dependent => :destroy

   # this is for folders which the user has been shared by others
   has_many :being_shared_folders, :class_name => "SharedFolder", :foreign_key => "shared_user_id", :dependent => :destroy
   #this is for getting Folders objects which the user has been shared by other users  
   has_many :shared_folders_by_others, :through => :being_shared_folders, :source => :folder
 
   after_create :check_and_assign_shared_ids_to_shared_folders

    # this is to make sure the id of the new user of which the email addresses already used to share folders by others, have access to those folders
    def check_and_assign_shared_ids_to_shared_folders
      # first check if the new user's email exists in any of the shared folder records
      shared_folders_with_same_email = SharedFolder.find_all_by_shared_email(self.email)

      if shared_folders_with_same_email
        # loop and update the shared user id with this new user id
        shared_folders_with_same_email.each do |shared_folder|
          shared_folder.shared_user_id = self.id
          shared_folder.save
        end
      end
    end
    # to check if a user has access to this specific folder
    def has_share_access?(folder)
      # doesn't have share access if folder is nil (i.e., file is top-level)
      return false if folder.nil?

      # has share access if the folder is one of his own
      return true if self.folders.include?(folder)

      # has share access if the folder is one of the shared_folders_by_others
      return true if self.shared_folders_by_others.include?(folder)

      # for checking sub folders under one of the being_shared_folders
      return_value = false

      folder.ancestors.each do |ancestor_folder|
        return_value = self.being_shared_folders.include?(ancestor_folder)
        if return_value # if its true
          return true
        end
      end

      return false
    end
    
    def data_usage
      current_user_data_usage = current_user.uploads.sum(:uploaded_file_file_size)
    end
    
    def max_data_usage
      uploaded_file_max_data_usage  = 1
    end
    
    private

    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation, :remember_me)
    end    
end
