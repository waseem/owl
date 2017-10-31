class Shop < ApplicationRecord
  include ShopifyApp::SessionStorage

  has_many :products
  has_many :questions
  has_many :customers
end
