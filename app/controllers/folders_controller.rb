class FoldersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @folders = current_user.folders
     respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @folders}
     end
  end

  def show
    @folder = current_user.folders.find(params[:id])
  end

  def new
    @folder = current_user.folders.new     
    #if there is "folder_id" param, we know that we are under a folder, thus, we will essentially create a subfolder
    if params[:folder_id] #if we want to create a folder inside another folder

      #we still need to set the @current_folder to make the buttons working fine
      @current_folder = current_user.folders.find(params[:folder_id])

      #then we make sure the folder we are creating has a parent folder which is the @current_folder
      @folder.parent_id = @current_folder.id
    end
  end

  def create
    @folder = current_user.folders.new(folder_params)
    if @folder.save
        flash[:notice] = "Successfully created folder."
        if @folder.parent # checking if we have a parent folder on this one
          redirect_to browse_path(@folder.parent) # then we redirect to the parent folder
        else
          redirect_to root_url # if not, redirect back to home page
        end
      else
        render :action => 'new'
      end
    end

  def edit  
      @folder = current_user.folders.find(params[:folder_id])  
      @current_folder = @folder.parent    #this is just for breadcrumbs  
  end  

  def update
    @folder = current_user.folders.find(params[:id])
    if @folder.update_attributes(folder_params)
      redirect_to @folder, :notice  => "Successfully updated folder."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @folder = current_user.folders.find(params[:id])
    @parent_folder = @folder.parent # grabbing the parent folder
 
    @folder.destroy
    flash[:notice] = "Successfully deleted the folder and all the contents inside."
    
    # redirect to a relevant path depending on the parent folder
    if @parent_folder
      redirect_to browse_path(@parent_folder)
    else
      redirect_to root_url
    end
  end
  
  private

    def folder_params
      params.require(:folder).permit(:name, :parent_id, :user_id)
    end
end
