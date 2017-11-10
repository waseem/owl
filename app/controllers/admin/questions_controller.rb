module Admin
  class QuestionsController < BaseController
    def show
      @question = current_shop.questions.find(params[:id])
      @shopify_product = ShopifyAPI::Product.find(@question.product.shopify_id)
    end
  end
end
