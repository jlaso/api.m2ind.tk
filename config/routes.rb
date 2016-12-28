Rails.application.routes.draw do
  resources :game_tries
  resources :games
  resources :scores
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
