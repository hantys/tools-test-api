Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  namespace :api, defaults: { format: :json }, constraints: {subdomain: 'api' }, path: "/" do
    namespace :v1 do
      # devise_for :users
      resources :users
    end
  end
end
