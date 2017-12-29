module Admin
  class DashboardsController < BaseController
    def show
      redirect_to admin_questions_url(published: false)
    end
  end
end
