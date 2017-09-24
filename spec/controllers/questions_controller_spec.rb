require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe "#create" do
    let(:shop) { mock_model(Shop) }

    context "application is not installed" do
      it "response is unauthorized" do
        expect(Shop).to receive(:find_by_shopify_domain).with('non-existing').and_return(nil)

        post :create, params: { product_id: 'foo', shop: "non-existing" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "application is installed" do
      let(:product) { mock_model(Product) }

      before do
        expect(Shop).to receive(:find_by_shopify_domain).with('existing-shop-domain').and_return(shop)
      end

      context "product is unavailable" do
        before do
          expect(shop).to receive_message_chain(:products, :find_by_shopify_id).with('non-existing-product-id').and_return(nil)
          expect(shop).to receive_message_chain(:products, :build).with(shopify_id: 'non-existing-product-id').and_return(product)
        end

        context "product is saved unsuccessfully" do
          xit "response is error" do # Fails because of https://github.com/rspec/rspec-rails/issues/707#issuecomment-292793085
            expect(product).to receive(:save).with(no_args).and_return(false)

            post :create, params: { product_id: 'non-existing-product-id', shop: 'existing-shop-domain' }
            expect(response).to have_http_status(:internal_server_error)
          end
        end

        context "product is saved successfully" do
          # Behaves like when product is available.
          # Fails because of https://github.com/rspec/rspec-rails/issues/707#issuecomment-292793085
        end
      end

      context "product is available" do
        let(:question) { mock_model(Question) }

        before do
          allow(shop).to receive_message_chain(:products, :find_by_shopify_id).with('existing-product-id').and_return(product)
          expect(product).to receive_message_chain(:questions, :build).with(body: 'a question body').and_return(question)
        end

        context "question is saved successfully" do
          it "redirects to referer" do
            expect(question).to receive(:save).with(no_args).and_return(true)

            request.env['HTTP_REFERER'] = 'http://example.com'
            post :create, params: { product_id: 'existing-product-id', shop: "existing-shop-domain", body: "a question body" }
            expect(response).to be_redirect
          end
        end

        context "question is saved unsuccessfully" do
          it "response is bad request" do
            expect(question).to receive(:save).with(no_args).and_return(false)

            post :create, params: { product_id: 'existing-product-id', shop: "existing-shop-domain", body: "a question body" }
            expect(response).to have_http_status(:bad_request)
          end
        end
      end
    end
  end
end
