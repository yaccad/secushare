Secushare::Application.routes.draw do
  
  resources :folders
  resources :uploads
  resources :shared_folders
  
  devise_for :users
 
  
  #this route is for file downloads  
  match "uploads/get/:id" => "uploads#get", :as => "download", via: [:get]
  
  match "browse/:folder_id" => "home#browse", :as => "browse", via: [:get]
  
  #For creating folders inside another folder
  match "browse/:folder_id/new_folder" => "folders#new", :as => "new_sub_folder", via: [:get]
  
  #for uploading files to folders  
  match "browse/:folder_id/new_file" => "uploads#new", :as => "new_sub_file", via: [:get]
  
  #for renaming a folder  
  match "browse/:folder_id/rename" => "folders#edit", :as => "rename_folder", via: [:get]
  
  #for sharing the folder
  match "home/share" => "home#share", via: [:post]
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
   root :to => "home#index"
end
