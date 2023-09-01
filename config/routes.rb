Rails.application.routes.draw do

  devise_scope :user do
    devise_for :users
    root to: 'devise/sessions#new'
    delete 'users/sign_out' => 'devise/sessions#destroy'
  end

  resources :users

  get 'index' => 'home#index'

  get 'times/index' => 'times#index'
  get 'times/new' => 'times#new'
  get 'times/:id' => 'times#show'
  get 'times/create' => 'times#create'
  get 'times/:id/edit' => 'times#edit'
  post 'times/:id/update' => 'times#update'
  delete 'times/:id/destroy' => 'times#destroy'

  get 'posts/new' => 'posts#new'
  post 'posts/create' => 'posts#create'
  get 'posts/:id/edit' => 'posts#edit'
  post 'posts/:id/update' => 'posts#update'
  delete 'posts/:id/destroy' => 'posts#destroy'
  get 'posts/:day' => 'posts#show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end