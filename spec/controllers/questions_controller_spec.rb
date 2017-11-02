require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  render_views
  fixtures :shops, :products, :questions, :customers

  describe "#create" do
    let!(:shop) { shops(:stylo) }

    context "application is not installed" do
      it "response is unauthorized" do
        post :create, params: { product_id: 'foo', shop: "non-existing" }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "application is installed" do
      let!(:product) { products(:shirt)  }

      context "product is unavailable" do
        before do
          expect(shop).to receive_message_chain(:products, :find_by_shopify_id).with('non-existing-product-id').and_return(nil)
          expect(shop).to receive_message_chain(:products, :build).with(shopify_id: 'non-existing-product-id').and_return(product)
        end

        context "product is saved unsuccessfully" do
          xit "response is error" do # Fails because of https://github.com/rspec/rspec-rails/issues/707#issuecomment-292793085
            expect(product).to receive(:save).with(no_args).and_return(false)

            post :create, params: { product_id: 'non-existing-product-id', shop: 'existing-shop-domain' }, format: :json
            expect(response).to have_http_status(:internal_server_error)
          end
        end

        context "product is saved successfully" do
          # Behaves like when product is available.
          # Fails because of https://github.com/rspec/rspec-rails/issues/707#issuecomment-292793085
        end
      end

      context "product is available" do
        shared_examples "question saving" do
          context "question is saved successfully" do
            it "renders question json" do
              post :create, params: {
                product_id: product.shopify_id, shop: shop.shopify_domain,
                body: "a valid question body", customer: customer_params
              }, format: :json

              expect(response).to have_http_status(:success)

              json = ActiveSupport::JSON.decode(response.body)
              expect(json["question"]["id"]).to be_present
              expect(json["question"]["body"]).to eq("a valid question body")
              expect(json["question"]["shopify_product_id"]).to eq(product.shopify_id)
              expect(json["question"]["created_at"]).to be_present
            end
          end

          context "question is saved unsuccessfully" do
            it "response is bad request" do
              post :create, params: {
                product_id: product.shopify_id, shop: shop.shopify_domain,
                body: "", customer: customer_params
              }, format: :json
              expect(response).to have_http_status(:bad_request)
            end
          end
        end

        context "customer is unavailable" do
          context "no customer identifier" do
            it "response is bad request" do
              post :create, params: {
                product_id: product.shopify_id, shop: shop.shopify_domain,
                body: "a question body", customer: {
                  shopify_id: "", email: "", name: ""
                }
              }, format: :json
              expect(response).to have_http_status(:unauthorized)
            end
          end

          context "customer is saved successfully" do
            it_behaves_like "question saving" do
              let(:customer_params) {
                {
                  name: "Customer Name",
                  email: "customer@shopify.com"
                }
              }
            end
          end

          context "customer is saved unsuccessfully" do
            it "renders bad request" do
              post :create, params: {
                product_id: product.shopify_id, shop: shop.shopify_domain,
                body: "a question body", customer: {
                  shopify_id: "", email: "customer@shopify.com", name: ""
                }
              }, format: :json
              expect(response).to have_http_status(:bad_request)
            end
          end
        end

        context "customer is available" do
          it_behaves_like "question saving" do
            let!(:customer) { customers(:without_shopify_id) }
            let(:customer_params) {
              {
                name: customer.name,
                email: customer.email,
                shopify_id: customer.shopify_id
              }
            }
          end

          it_behaves_like "question saving" do
            let!(:customer) { customers(:with_shopify_id) }
            let(:customer_params) {
              {
                name: customer.name,
                email: customer.email,
                shopify_id: customer.shopify_id
              }
            }
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

        post :index, params: { product_id: 'foo', shop: "non-existing" }, format: :json
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
          questions = product.questions.limit(10)
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
