Utilities::Application.routes.draw do |map|
#  map.resources :city_types, :has_many => :cities
#  map.resources :cities, :has_many => :street_locations,
#    :collection => { :city_print => :get,
#    :index_active_cities => :get}
#  map.resource :user_session
#  map.root :controller => "user_sessions", :action => "new"

  resource :user_session
  root :to => 'user_sessions#new'
#  root :to => 'cities#index'
  resources :cities do
    collection do
      get :city_print, :index_active_cities
    end
  end

  resources :regions do
  end 

  resources :firms do
  end 

  resources :orders do
  end 

  resources :users do
  end 


  resource :password

  resources :bankunits do
  end 

  resources :counters do
  end 

  resources :counter_readings do
  end 

  resources :bankbook_attributes_debts do
  end 
  

#  match ':payers/:order_print/:code_erc/:id_city'
#  match 'payers/:code_erc/:id_city' => 'payers#order_print', :via => :post
  resources :payers do
#    get 'order_print', :on => :member
    collection do
      post :search, :order_print, :update_count_debt
      get :show, :order, :test, :debt, :passport, :passport_print, :show_payers, :show_housing, :show_tariffs,
        :show_exemptions, :show_histories, :find_payer_by_address, :order_print, :update_counters
    end
  end 

  resource :profile do
  end 

  resource :settings do
  end 

  resource :user_session do
  end 

  resources :filials do
  end 

  resources :street_locations do
    collection do
      get :actual_streets
    end
  end 

  resources :house_locations

  resources :room_locations
#  map.resources :houses, :has_many => :house_locations
#  map.resources :house_locations, :has_many => :room_locations


  resources :zips do
    collection do
      get :show_map
    end
  end 


#  map.resources :zips, :collection => { :show_map => :get} 

#  map.resources :humans, :has_many => :bankbooks, 
#    :collection => { :show_payers => :get, 
#      :show_housing => :get, :show_tariffs => :get, 
#      :show_exemptions => :get,
#      :show_histories => :get,
#      :search => :get,
#      :find_payer_by_address => :get,
#      :passport_print => :get,
#      :order_print => :get,
#      :debt => :get,
#      :passport => :get,
#      :test => :get,
#      :order => :get }


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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
