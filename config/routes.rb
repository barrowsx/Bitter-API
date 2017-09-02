Rails.application.routes.draw do
  resources :users, only: [:create]
  post '/login', to: 'sessions#create'

  namespace :api do
    namespace :v1 do
      get '/users/current', to: 'users#current_user_data'
      get '/users/current/following_posts', to: 'users#following_posts'
      resources :users, only: [:show, :update, :destroy]
      resources :posts
      get '/users/:id/posts', to: 'users#posts'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
