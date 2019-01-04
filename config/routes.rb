Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  devise_for :users, only: [:sessions], controllers: {sessions: 'api/v1/sessions'}

  namespace :api, defaults: { format: :json }, constraints: {subdomain: 'api' }, path: "/" do
    namespace :v1 do
      resources :users
      resources :sessions, only: [:create, :destroy]
    end
  end
end
