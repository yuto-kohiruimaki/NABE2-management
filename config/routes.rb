Rails.application.routes.draw do

  devise_scope :user do
    devise_for :users
    root to: 'devise/sessions#new'
    delete 'users/sign_out' => 'devise/sessions#destroy'
  end

  resources :users

  resources :times

  resources :posts

  get 'index' => 'home#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end