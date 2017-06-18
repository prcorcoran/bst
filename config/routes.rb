Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'verse#show'
#match ':controller/:action/:id', via: [:get, :post]
   get 'verse/search'
   get 'verse/add_advanced_search_line'
   get 'verse/remove_advanced_search_line'
   get 'verse/show_help'
   get 'verse/show_advanced_search_form'
   get 'verse/show_simple_search_form'
   get 'verse/next_verse/:id' => 'verse#next_verse', :as => 'verse_next_verse'
   get 'verse/prev_verse/:id' => 'verse#prev_verse', :as => 'verse_prev_verse'
   get 'verse/next_chapter/:id' => 'verse#next_chapter', :as => 'verse_next_chapter'
   get 'verse/prev_chapter/:id' => 'verse#prev_chapter', :as => 'verse_prev_chapter'
   get 'verse/next_book/:id' => 'verse#next_book', :as => 'verse_next_book'
   get 'verse/prev_book/:id' => 'verse#prev_book', :as => 'verse_prev_book'
   get 'verse/key_F5_pressed/:id' => 'verse#key_F5_pressed', :as => 'verse_key_F5_pressed' 
   get 'verse/key_F4_pressed/:id' => 'verse#key_F4_pressed', :as => 'verse_key_F4_pressed' 
   get 'verse/advanced_search'
   get 'verse/find'
   get 'verse/find_ajax'
   get 'verse/show_ajax/:id' => 'verse#show_ajax', :as => :verse_show_ajax
#   get 'verse/key_F4_pressed/:id'
   post 'verse/find'
   post 'verse/search'
   post 'verse/advanced_search'
   post 'verse/clear_search_results'
  #  map.connect ':controller/:action/:id'
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
