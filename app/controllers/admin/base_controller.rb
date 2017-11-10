module Admin
  class BaseController < ShopifyApp::AuthenticatedController
    helper_method :current_shop
    before_action :shop_required

    private

    def current_shop
      @current_shop ||= Shop.find_by_shopify_domain(@shop_session.shop.domain)
    end

    def shop_required
      # In case someone tries to access application not being embedded in shopify admin.
      # Ask them to access it over shopify admin.
    end
  end
end
