module Admin
  class QuestionsController < BaseController
    before_action :get_question, only: [:show, :update]

    def show
      @shopify_product = ShopifyAPI::Product.find(@question.product.shopify_id)
      @answer = @question.answers.build
    end

    def index
      @questions = current_shop.questions.where(published: params[:published]).page(params[:page])
    end

    def update
      @question.toggle!(:published)
      redirect_to admin_question_url(@question.id)
    end

    private

    def get_question
      @question = current_shop.questions.find(params[:id])
    end
  end
end
