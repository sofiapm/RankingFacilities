Rails.application.routes.draw do


 

  get 'granular_measure/new'

  get 'granular_measure/create'

  get 'granular_measure/edit'

  get 'granular_measure/update'

  get 'granular_measure/destroy'

  get 'indicators' => 'indicators#index'

  get 'metrics' => 'metrics#index'

  get 'details' => 'details#index'

  get 'error_you_can_not_access_page' => 'static_pages#error_you_can_not_access_page'
  get 'error_role_empty_page' => 'static_pages#error_role_empty_page'
  get 'success_page' => 'static_pages#success_page'
  get 'home' => 'static_pages#home'
  get "user_roles/update" => "user_roles#update"
  put "user_roles/update" => "user_roles#update"
  get "user_roles/update_state" => "user_roles#update_state"
  put "user_roles/update_state" => "user_roles#update_state"

  # get '*unmatched_route', :to => 'application#raise_not_found!'

  resources :sites

  resources :addresses
  #resources :facility_static_measures
  
  resources :roles, shallow: true do
    resources :facilities do
        resources :measures, :facility_static_measures, :kpis  do
          collection { post :import }
        end
    end
  end

  devise_for :users, :controllers => {:registrations => "my_devise/registrations"}

  root to: 'static_pages#home_page'
  
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
end
