Rails.application.routes.draw do

  # API
  namespace :api, path: '/api' do
    resources :games
  end

  root 'site#index'

  # Admins
  devise_for :admins
  # devise_for :pod_admins,
  #   controllers: {
  #     sessions: "pod_admins/sessions",
  #     registrations: "pod_admins/registrations"
  #  }

  devise_scope :admin do
    get "/admin/logout" => "devise/sessions#destroy"
    get "/admin/signup", to: "devise/registrations#new", as: "admin_signup"
    get "/admin/login", to: "devise/sessions#new", as: "admin_login"
  end

  get '/admin', to: 'admin#index'
  namespace :admin do
    resources :games
    resources :pods
    resources :pod_admins
  end

  get '/pod_admin', to: 'pod_admin#index'
  namespace :pod_admin do
    resources :parents
  end


end
