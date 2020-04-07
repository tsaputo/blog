Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  get 'welcome/index'
  
  resources :users

  resources :articles do
    resources :comments
  end

  root 'welcome#index'  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
