class QuestionsController < ApplicationController
  if Rails.env != 'test'
    include ShopifyApp::AppProxyVerification
  end

  def create
    shop = Shop.find_by_shopify_domain(params[:shop])
    unless shop
      respond_to do |format|
        format.html { head :unauthorized }
      end
      return
    end

    product = shop.products.find_by_shopify_id(params[:product_id])
    if product.blank?
      product = shop.products.build(shopify_id: params[:product_id])
      unless product.save
        respond_to do |format|
          format.html { head :internal_server_error } # Something went wrong saving the product
        end
        return
      end
    end

    question = product.questions.build(body: params[:body])
    if question.save
      respond_to do |format|
        format.html { redirect_to request.referer }
      end

    else
      respond_to do |format|
        format.html { head :bad_request } # Question is invalid. Tell the client what is invalid about it.
      end
    end
  end
end
