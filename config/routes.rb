Rails.application.routes.draw do
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

      resources :topics, only: :index
    end
  end
end
