Use::Application.routes.draw do

  get "display/projection"
  get "display/tv"
  resources :settings

  get 'users/show_public/:id' => 'users#show_public'
  get 'users/new_public' => 'users#new_public'
  post 'users/create_public' => 'users#create_public'
  resources :users
    
  get 'transactions/new_public' => 'transactions#new_public'  
  get 'transactions/add_cash_public' => 'transactions#add_cash_public'  
  post 'transactions/create_public' => 'transactions#create_public'  
  get 'transactions/transaction_result' => 'transactions#transaction_result'  
  resources :transactions

  get 'stocks/chart/:id' => 'stocks#chart'
  get 'stocks/overview' => 'stocks#overview'
  get 'stocks/show_gallery/:id' => 'stocks#show_gallery'
  get 'stocks/next/:id' => 'stocks#next'
  get 'stocks/previous/:id' => 'stocks#previous'
  resources :stocks

  get 'show/:id' => 'welcome#index'
  post 'utopias/create' => 'utopias#create_public'
  resources :utopias

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  get '/old' => 'welcome#index'

  root 'welcome#new'

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
