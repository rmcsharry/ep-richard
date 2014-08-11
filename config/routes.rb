Rails.application.routes.draw do

  namespace :api, path: '/api' do
    resources :games
  end

  root 'site#index'

end
