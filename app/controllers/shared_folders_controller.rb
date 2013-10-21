class SharedFoldersController < ApplicationController
  
  def destroy
    @shared_folder = current_user.shared_folders.find(params[:id])
    session[:return_to] ||= request.referer
 
    @shared_folder.destroy
    flash[:notice] = "Successfully deleted the contact."
    
    # redirect to shared folder
   
    redirect_to session.delete(:return_to)
  
  end

end
