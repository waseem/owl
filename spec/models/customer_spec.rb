require 'rails_helper'

RSpec.describe Customer, type: :model do
  fixtures :shops

  describe "valid customer" do
    let!(:shop) { shops(:stylo) }
    let(:customer) { Customer.new(shop: shop) }

    context "without shopify id" do
      it "is invalid without name" do
        customer.email = "foo@bar.com"
        expect(customer).not_to be_valid
      end

      it "is invalid without email" do
        customer.name = "Foo"
        expect(customer).not_to be_valid
      end

      it "is valid with email and name" do
        customer.name = "Foo"
        customer.email = "foo@bar.com"
        expect(customer).to be_valid
      end
    end

    context "with shopify id" do
      it "is valid" do
        customer.shopify_id = 8765438
        expect(customer).to be_valid
      end
    end
  end
end
