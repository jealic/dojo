Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'posts#index'
  resources :posts do
    resources :replies
    
    collection do
      get :feeds
    end
    member do
      post :collect
      post :uncollect
    end
  end

  namespace :admin do
    root 'categories#index'
    resources :categories
    resources :users
  end

  resources :categories, only: :show

  resources :friendships, only: :create do
    member do
      post :accept
      delete :ignore
    end
  end

  resources :users do
    member do
      get :show_reply
      get :show_draft
      get :show_collect
      get :show_friend
    end
  end

  namespace :api, default: {format: :json} do
    namespace :v1 do
      resources :posts, only: [:index, :create, :show, :update, :destroy]
    end
  end
end
