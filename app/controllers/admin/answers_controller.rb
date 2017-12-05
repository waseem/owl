module Admin
  class AnswersController < BaseController
    before_action :get_question

    def create
      @answer = @question.answers.build(answer_params)
      @answer.shop_id = @question.shop_id
      @shopify_product = ShopifyAPI::Product.find(@question.product.shopify_id)

      if @answer.save
        flash[:notice] = "Answer saved successfully!"
        redirect_to admin_question_url(@question)
      else
        flash[:error] = "Something went wrong saving the answer. Please correct the errors and try again."
        render "admin/questions/show"
      end
    end

    def edit
      @answer = @question.answers.find(params[:id])
    end

    def update
      @answer = @question.answers.find(params[:id])
      if @answer.update_attributes(answer_params)
        flash[:notice] = "Answer saved successfully!"
        redirect_to admin_question_url(@question)
      else
        flash[:error] = "Something went wrong saving the answer. Please correct the errors and try again."
        render :edit
      end
    end

    def destroy
      @answer = @question.answers.find(params[:id])

      if @answer.destroy
        flash[:notice] = "Answer saved successfully!"
      else
        flash[:error] = "Something went wrong saving the answer. Please correct the errors and try again."
      end

      redirect_to admin_question_url(@question)
    end

    private

    def get_question
      @question = current_shop.questions.find(params[:question_id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
  end
end
