Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'cabs#index'
  
  resource :cabs
  
  # ===== Rides routes =============

  post '/start_ride' => 'rides#start_ride', as: 'start_ride'
  put '/stop_ride/:id' => 'rides#stop_ride', as: 'stop_ride'

  # ================================


end
