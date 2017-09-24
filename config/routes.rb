Rails.application.routes.draw do
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'

# POST /:product_id/questions Create
# GET  /:product_id/questions Index
# POST /:question_id/answers Create
# GET /:question_id/answers Index

  resources :products, only: [] do # No need for routes related to products
    resources :questions, only: [:index, :create]
  end
end
