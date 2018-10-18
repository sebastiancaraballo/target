Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  mount_devise_token_auth_for 'User', at: '/api/v1/users', controllers: {
    registrations:  'api/v1/registrations',
    passwords:  'api/v1/passwords',
    sessions:       'api/v1/sessions'
  }

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      devise_scope :user do
        get :status, to: 'api#status'
      end
      namespace :user do
        resources :matches, only: :index
      end

      resources :topics, only: :index
      resources :spots, only: %i[create index destroy]
      resources :conversations, only: %i[create index]
    end
  end
end
