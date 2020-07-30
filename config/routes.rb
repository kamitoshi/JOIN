Rails.application.routes.draw do
  root 'home#top'
  get 'home/about'
  devise_for :users, controllers:{
    sessions: "users/sessions",
    passwords: "users/passwords",
    registrations: "users/registrations"
  }
  devise_scope :user do
    get 'users/confirm_email', to: 'users/registrations#confirm_email'
  end
  resources :users, only:[:index, :show, :edit, :update, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
