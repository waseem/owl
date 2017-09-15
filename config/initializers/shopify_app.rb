ShopifyApp.configure do |config|
  config.application_name = "Product Questions"
  config.api_key = ENV['SHOPIFY_CLIENT_API_KEY']
  config.secret = ENV['SHOPIFY_CLEINT_API_SECRET']
  config.scope = "read_products"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
end
