require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  render_views
  fixtures :shops, :products, :questions

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
        before do
          allow(shop).to receive_message_chain(:products, :find_by_shopify_id).with('existing-product-id').and_return(product)
        end

        shared_examples "question saving" do |customer_params|
          let(:question) { mock_model(Question) }
          before do
            expect(product).to receive_message_chain(:questions, :build).with(body: 'a question body', shop: shop, asker: customer).and_return(question)
          end

          context "question is saved successfully" do
            it "redirects to referer" do
              expect(question).to receive(:save).with(no_args).and_return(true)

              request.env['HTTP_REFERER'] = 'http://example.com'
              post :create, params: {
                product_id: 'existing-product-id', shop: "existing-shop-domain",
                body: "a question body", customer: customer_params
              }
              expect(response).to be_redirect
            end
          end

          context "question is saved unsuccessfully" do
            it "response is bad request" do
              expect(question).to receive(:save).with(no_args).and_return(false)

              post :create, params: {
                product_id: 'existing-product-id', shop: "existing-shop-domain",
                body: "a question body", customer: customer_params
              }
              expect(response).to have_http_status(:bad_request)
            end
          end
        end

        context "customer is unavailable" do
          context "no customer identifier" do
            it "response is bad request" do
              post :create, params: {
                product_id: 'existing-product-id', shop: "existing-shop-domain",
                body: "a question body", customer: {
                  shopify_id: "", email: "", name: ""
                }
              }
              expect(response).to have_http_status(:bad_request)
            end
          end

          context "customer is saved successfully" do
            # Fails because of https://github.com/rspec/rspec-rails/issues/707#issuecomment-292793085
            #it_behaves_like "question saving" do
              #let(:customer) { mock_model(Customer) }
              #before do
                #expect(shop).to receive_message_chain(:customers, :find_by_email).with("customer@shopify.com").and_return(nil)
                #expect(shop).to receive_message_chain(:customers, :build).with(shopify_id: "", email: "customer@shopify.com", name: "Shopify Customer").and_return(customer)
                #expect(customer).to receive(:save).with(no_args).and_return(true)
              #end
            #end
          end

          context "customer is saved unsuccessfully" do
            # Fails because of https://github.com/rspec/rspec-rails/issues/707#issuecomment-292793085
          end
        end

        context "customer is available" do
          customer_params = {
            shopify_id: "",
            name: "Shopify Customer",
            email: "customer@shopify.com"
          }
          it_behaves_like "question saving", customer_params do
            let(:customer) { mock_model(Customer) }
            before do
              expect(shop).to receive_message_chain(:customers, :find_by_email).with("customer@shopify.com").and_return(customer)
            end
          end

          customer_params = {
            shopify_id: 84590016801,
            name: "",
            email: ""
          }
          it_behaves_like "question saving", customer_params do
            let(:customer) { mock_model(Customer) }
            before do
              expect(shop).to receive_message_chain(:customers, :find_by_shopify_id).with("84590016801").and_return(customer)
            end
          end
        end
      end
    end
  end

  describe "#index" do
    let!(:shop) { shops(:stylo) }
    context "application is not installed" do
      it "response is unauthorized" do
        expect(Shop).to receive(:find_by_shopify_domain).with('non-existing').and_return(nil)

        post :index, params: { product_id: 'foo', shop: "non-existing" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "application is installed" do
      context "product does not exist" do
        it "renders error json" do
          get :index, params: { product_id: 'non-existing', shop: shop.shopify_domain }, format: :json

          expect(response).to have_http_status(:not_found)
          json = ActiveSupport::JSON.decode(response.body)
          expect(json).to eq({"error" => "product does not exist" })
        end
      end

      context "product with questions exist" do
        let!(:product) { products(:shirt) }

        it "renders first four product questions json" do
          questions = product.questions.limit(4)
          expected_json = {"questions" => []}
          questions.each do |question|
            expected_json["questions"].push({
              "id" => question.id,
              "body" => question.body,
              "shopify_product_id" => product.shopify_id,
              "created_at" => question.created_at.strftime("%d %b, %Y")
            })
          end

          get :index, params: { product_id: product.shopify_id, shop: shop.shopify_domain }, format: :json

          expect(response).to have_http_status(:success)
          json = ActiveSupport::JSON.decode(response.body)
          expect(json).to eq(expected_json)
        end
      end
    end
  end
end
