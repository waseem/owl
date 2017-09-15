class Shop < ApplicationRecord
  include ShopifyApp::SessionStorage
end
