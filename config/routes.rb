Rails.application.routes.draw do
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount ActionCable.server => '/cable'
  mount_devise_token_auth_for 'User', at: '/api/v1/users', controllers: {
    registrations:  'api/v1/registrations',
    passwords:  'api/v1/passwords',
    sessions:       'api/v1/sessions'
  }

  root to: 'rails_admin/main#dashboard'
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      devise_scope :user do
        get :status, to: 'api#status'
        post 'users/facebook', to: 'sessions#facebook'
        resources :matches, only: :index
        resources :users, only: %i[show update]
      end

      resources :topics, only: :index
      resources :spots, only: %i[create index destroy]
      resources :conversations, only: %i[create index] do
        resources :messages, only: :index
      end
    end
  end
end
