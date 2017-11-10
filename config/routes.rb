Rails.application.routes.draw do
  root to: 'home#index' # This should be used when user comes to us without embedding in Shopify

  mount ShopifyApp::Engine, at: '/'

# POST /:question_id/answers Create
# GET /:question_id/answers Index

  resources :products, only: [] do # No need for routes related to products
    resources :questions, only: [:index, :create]
  end

  namespace :admin do
    root to: 'dashboards#show'
    resources :questions, except: [:new, :create]
  end
end
