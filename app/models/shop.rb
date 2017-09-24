class Shop < ApplicationRecord
  include ShopifyApp::SessionStorage

  has_many :products
end
