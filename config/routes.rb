Rails.application.routes.draw do

  get 'version', to: 'version#index'

  # game related routes # resources :games
  get 'games', to: 'games#index'
  post 'games', to: 'games#create'

  # game tries related routes (play turn and ask for played turns) # resources :game_tries
  get 'game_tries', to: 'game_tries#index'
  get 'game_tries/:id', to: 'game_tries#show'
  post 'game_tries', to: 'game_tries#create'

  # scores (results) related things, get high-scores or update name of user # resources :scores
  get 'scores', to: 'scores#index'
  get 'scores/:id', to: 'scores#show'
  put 'scores/:id', to: 'scores#update'

  # game hints related routes # resources :game_hints
  get 'game_hints', to: 'game_hints#index'
  get 'game_hints/:id', to: 'game_hints#show'
  post 'game_hints', to: 'game_hints#create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
