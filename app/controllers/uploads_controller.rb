class UploadsController < ApplicationController
   before_filter :authenticate_user!
  def index
    @uploads = current_user.uploads
    respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @uploads.map{|upload| upload.to_jq_upload } }
    end
  end

  def show
    @upload = current_user.uploads.find(params[:id])
  end

  def new  
    @upload = current_user.uploads.build      
    if params[:folder_id] #if we want to upload a file inside another folder  
     @current_folder = current_user.folders.find(params[:folder_id])  
     @upload.folder_id = @current_folder.id  
     
    end      
  end

  # def create
  #   
  #   @upload = current_user.uploads.build(upload_params)
  #   if @upload.save
  #     flash[:notice] = "Successfully uploaded the file." 
  #     @shared_folders = SharedFolder.all.where(folder_id: @upload.folder)
  #     @shared_folders.each do |shared_folder|
  #      # now we need to send email to recipients
  #       UserMailer.new_file_shared(shared_folder).deliver
  #       
  #     end
  #     
  #      if @upload.folder #checking if we have a parent folder for this file  
  #        redirect_to browse_path(@upload.folder)  #then we redirect to the parent folder  
  #      else  
  #        redirect_to root_url  
  #      end   
  #          
  #     else  
  #      render :action => 'new'  
  #     end  
  # end
    def create
      @upload = current_user.uploads.build(upload_params)

      respond_to do |format|
        if @upload.save
          @shared_folders = SharedFolder.all.where(folder_id: @upload.folder)
          @shared_folders.each do |shared_folder|
            UserMailer.new_file_shared(shared_folder).deliver
          end
          
          # format.html {
          #   render :json => [@upload.to_jq_upload].to_json,
          #   :content_type => 'text/html'
          # }
       
          
          format.json { render json: {files: [@upload.to_jq_upload]}, status: :created, location: @upload }
          
        else
          format.html { render action: "new" }
          format.json { render json: @upload.errors, status: :unprocessable_entity }
        end
      end
    end
 
 
 
 
  def edit
    @upload = current_user.uploads.find(params[:id])
  end

  def update
    @upload = current_user.uploads.find(params[:id])
    if @upload.update_attributes(upload_params)
      redirect_to @upload, :notice  => "Successfully updated upload."
    else
      render :action => 'edit'
    end
  end

  
  def destroy
     @upload = current_user.uploads.find(params[:id])
     @parent_folder = @upload.folder # grabbing the parent folder before deleting the record
     @upload.destroy
      flash[:notice] = "Successfully deleted the file."
      if @parent_folder
        redirect_to browse_path(@parent_folder)
      else
        redirect_to root_url
      end
   end
  
  #This action will let the users download the files (after a simple authorzation check)
  def get
    # first find the upload within own uploads
    upload = current_user.uploads.find_by_id(params[:id])
    
    #if not found in own uploads, check if the current_user has share access to the parent folder of the file
    upload ||= Upload.find(params[:id]) if current_user.has_share_access?(Upload.find_by_id(params[:id]).folder)
    
    if upload
      send_file upload.uploaded_file.path, :type => upload.uploaded_file_content_type
    else
      flash[:error] = "You have no permissions to access this area!!"
      redirect_to uploads_path
    end
   
  end

  
  private

    def upload_params
      params.require(:upload).permit(:user_id, :uploaded_file, :folder_id)
    end
  
end
