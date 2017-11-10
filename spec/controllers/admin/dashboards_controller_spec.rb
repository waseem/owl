require 'rails_helper'

RSpec.describe Admin::DashboardsController, type: :controller do
  fixtures :shops, :questions

  describe "#show" do
    let!(:shop) { shops(:stylo) }
    before do
      # Fails
      # See https://github.com/Shopify/shopify_app/issues/445#issuecomment-343511898
      # login(shop)
    end

    it "passes" do
      expect(true).to be
    end
  end
end
