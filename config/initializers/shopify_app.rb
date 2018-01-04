ShopifyApp.configure do |config|
  config.application_name = "Product Questions"
  config.api_key = ENV['SHOPIFY_CLIENT_API_KEY']
  config.secret = ENV['SHOPIFY_CLIENT_API_SECRET']
  config.scope = "read_products,read_script_tags,write_script_tags"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
  if %w(staging production).include?(Rails.env)
    config.scripttags = [
      {
        event: 'onload', src: 'https://indiarides.in/question.js'
      }
    ]
  end
end
