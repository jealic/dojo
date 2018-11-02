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

  resources :users do
    member do
      get :show_reply
      get :show_draft
      get :show_collect
    end
  end
end
