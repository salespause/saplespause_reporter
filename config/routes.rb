Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :captured_images, only: [:create]
    end
  end
end
