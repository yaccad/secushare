class AddFolderIdToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :folder_id, :integer
    add_index :uploads, :folder_id
  end
end
