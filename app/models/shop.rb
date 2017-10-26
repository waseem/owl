class Shop < ApplicationRecord
  include ShopifyApp::SessionStorage

  has_many :products
  has_many :questions
end
