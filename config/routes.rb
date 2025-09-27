Rails.application.routes.draw do

  devise_scope :user do
    devise_for :users
    root to: 'devise/sessions#new'
    delete 'users/sign_out' => 'devise/sessions#destroy'
  end

  resources :users

  resources :times

  resources :posts

  namespace :admin do
    resources :users, only: :index do
      patch :toggle_status, on: :member
    end
    resources :work_plans, only: [:index, :create]
    root to: 'dashboard#show', as: :root
  end

  get 'admin', to: 'admin/dashboard#show', as: :admin

  get 'index' => 'home#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
