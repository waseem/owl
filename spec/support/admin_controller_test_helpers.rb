module AdminControllerTestHelpers
  # Taken from https://github.com/Shopify/shopify_app/issues/445#issuecomment-332760958
  def login(shop)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:shopify, uid: shop.shopify_domain, credentials: { token: shop.shopify_token })
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:shopify]

    get "/auth/shopify"
  end
end
