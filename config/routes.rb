Prpgtn::Application.routes.draw do
    

  #use_doorkeeper
  
  devise_for :admins
  devise_for :users
  
  # api version: 1 do
  # 
  #   post 'channels/:channel_id/items', :to => 'api/items#create'
  #   get 'channels/:channel_id/items', :to => 'api/items#index'
  #   get 'items/:id', :to => 'api/items#show'
  #   
  # end
  
  resources :items, :links
  
  namespace :popup do
  
    resources :items
    
  end
  
  namespace :admin do 
    
    resources :users, :links, :items
    resources :channels do
      member do 
        get 'subscribers', 'items'
      end
    end
  end
 
  resources :channels, :only => [:new, :create, :index, :show, :destroy] do
    
    member do
      put 'leave'
    end
    
    resources :channel_invites, :shallow => true do
      member do
        put 'accept', 'decline'
      end
    end
  end
  
  match 'user/invites' => 'channel_invites#index', :as => :invites

  root :to => "channels#index"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
