class QuestionsController < ApplicationController
  if Rails.env != 'test'
    include ShopifyApp::AppProxyVerification
  end

  before_action :get_shop, :get_product
  before_action :get_customer, only: [:create]

  def create
    if @product.blank?
      @product = @shop.products.build(shopify_id: params[:product_id])
      unless @product.save
        respond_to do |format|
          # Something went wrong saving the product
          format.json { render(json: { error: "product did not save" }, status: :internal_server_error) }
        end
        return
      end
    end

    if @customer.blank?
      @customer = @shop.customers.build(shopify_id: params[:customer][:shopify_id], name: params[:customer][:name], email: params[:customer][:email])
      unless @customer.save
        respond_to do |format|
          # Customer is invalid. Tell the client what is invalid about it.
          format.json { render(json: { error: "customer creation failed" }, status: :bad_request) }
        end
        return
      end
    end

    @question = @product.questions.build(body: params[:body], shop: @shop, asker: @customer)
    if @question.save
      respond_to do |format|
        format.json { render("questions/show") }
      end

    else
      respond_to do |format|
        # Question is invalid. Tell the client what is invalid about it.
        format.json { render(json: { error: "question creation failed" }, status: :bad_request) }
      end
    end
  end

  def index
    if @product.blank?
      respond_to do |format|
        format.json { render(json: { error: "product does not exist" }, status: :not_found) }
      end
      return
    end

    @questions = @product.questions.published.page(params[:page]).per(4)
    respond_to do |format|
      format.json
    end
  end

  private

  def get_shop
    @shop = Shop.find_by_shopify_domain(params[:shop])
    unless @shop
      respond_to do |format|
        format.json { render(json: { error: "shop not found" }, status: :unauthorized) }
      end
      return
    end
  end

  def get_product
    @product = @shop.products.find_by_shopify_id(params[:product_id])
  end

  def get_customer
    if params[:customer][:shopify_id].present?
      @customer = @shop.customers.find_by_shopify_id(params[:customer][:shopify_id])

    elsif params[:customer][:email].present?
      @customer = @shop.customers.find_by_email(params[:customer][:email])

    else
      respond_to do |format|
        format.json { render(json: { error: "email can not be blank" }, status: :unauthorized) }
      end
      return
    end
  end
end
