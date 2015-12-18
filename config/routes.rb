Rails.application.routes.draw do

  # API
  namespace :api, path: '/api' do
    resources :parents
    resources :games
    resources :comments
    post '/log', to: 'log#ping'
  end

  root 'site#index'

  # Admins
  devise_for :admins

  devise_scope :admin do
    get '/admin/logout' => 'devise/sessions#destroy'
    get '/admin/signup', to: 'devise/registrations#new', as: 'admin_signup'
    get '/admin/login', to: 'devise/sessions#new', as: 'admin_login'
  end

  get '/admin', to: 'admin#index'
  namespace :admin do
    resources :games
    resources :pods
    resources :pod_admins
  end

  match '/pod_admin/set_go_live_date_for_pod/:id', to: 'pod_admin#set_go_live_date_for_pod', via: [:post]
  match '/pod_admin/send_welcome_sms/:id', to: 'pod_admin/parents#send_welcome_sms', via: [:post]

  namespace :pod_admin do
    get '/', to: :index
    get '/dashboard', to: :dashboard
    get '/analytics', to: :analytics
    get '/comments', to: :comments
    resources :parents
    resources :games
  end

end
