Rails.application.routes.draw do
  resources :users, only: [:create]
  post '/login', to: 'sessions#create'

  namespace :api do
    namespace :v1 do
      get '/users/current', to: 'users#current_user_data'
      get '/users/current/following_posts', to: 'users#following_posts'
      get '/users/current/following', to: 'users#following'
      get '/users/current/followers', to: 'users#followers'
      resources :users, only: [:show, :update, :destroy]
      resources :posts
      post '/posts/:id/like', to: 'posts#like_post'
      get '/posts/:id/like', to: 'posts#load_post_likes'
      get '/users/:id/posts', to: 'users#posts'
      post '/users/:id/follow', to: 'users#follow'
      get '/users/:id/follow', to: 'users#is_following?'
      get '/:username', to: 'users#show_by_username'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
