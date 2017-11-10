module Admin
  class DashboardsController < BaseController
    def show
      @questions = current_shop.questions.new_first.page(params[:page])
    end
  end
end
