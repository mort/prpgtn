Peach::Application.routes.draw do
    
  resources :roboto_requests

  namespace :api do
    namespace :v0 do
      resources :items do
        resources :emotings
      end
    end
  end

  require 'sidekiq/web'

  use_doorkeeper
  
  devise_for :admins
  devise_for :users 
    
  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  resources :items, :links
  resources :robotos, :only => [:show, :index]
  resources :feeds, :only => [:show, :index]
  
  
  namespace :api do 
  
    api_version(:module => "v0", :header => {:name => "Accept", :value => "application/vnd.grabapeach.com; version=0"}, :path => {:value => "v0"}) do

      match 'me' => 'users#me', :via => :get
      match 'stream' => 'users#stream', :via => :get
  
      resources :channels, :only => [:index, :show] do
        resources :users, :only => [:index] 
      end

    end
  
  end
  
  
  namespace :popup do
  
    resources :items
    
  end
  
  namespace :admin do 
    
    resources :users, :links, :items, :feeds
    
    resources :robotos do
      
      patch 'fire', on: :member
    
    end
    
    resources :channels do
      member do 
        get 'subscribers', 'items'
      end
    end
    
  end
 
  resources :channels, :only => [:new, :create, :index, :show, :destroy] do
    
    patch 'leave', on: :member
    
    resources :items do
      get 'jump', on: :member
    end
    
    resources :roboto_requests, :only => [:create, :show]
    
    resources :channel_subs, :only => :destroy
    
    resources :channel_invites, :shallow => true do
      member do
        put 'accept', 'decline'
      end
    end
    
  end
  
  resource :user_settings, :only => [:edit, :update]
  
  
  get 'user/invites' => 'channel_invites#index', :as => :invites
  get 'onboarding' => 'onboarding#step', :as => :onboarding
  
  get 'peach/v0' => 'peach#v0', :as => :peach_0
  
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
