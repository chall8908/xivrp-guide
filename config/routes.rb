Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'events#index'

  get :about, to: 'static#about'
  get 'terms-of-service', to: 'static#terms_of_service'
  get 'privacy-policy', to: 'static#privacy_policy'

  resources :events, param: :slug

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
