require 'rails_helper'

RSpec.describe CreatesOrder do
  describe "#from_list(user, a_list_of_ids_and_quantities)" do
    let!(:user)   { Fabricate(:user)         }
    let!(:order)  { Fabricate(:order)        }
    let!(:p1)     { Fabricate(:product)      }
    let!(:p2)     { Fabricate(:product)      }
    let!(:a_list) { [[p1.id, 1], [p2.id, 1]] }

    it "creates an order" do
      expect do
        CreatesOrder.new(user).from_list(a_list)
      end.to change(Order, :count).by(1)
    end

    it "creates product entries for each ordered product" do
      expect do
        CreatesOrder.new(user).from_list(a_list)
      end.to change(ProductEntry, :count).by(2)
    end

    it "returns a new order" do
      expect(CreatesOrder.new(user).from_list(a_list)).to be_instance_of(Order)
    end

    it "decreases the product quantity" do
      expect do
        CreatesOrder.new(user).from_list(a_list)
        p1.reload
      end.to change(p1, :quantity).by(-1)
    end
  end

  describe "#add_product_entry(product_id, quantity)" do
    it "works with strings" do
      user = Fabricate(:user)
      product = Fabricate(:product)

      expect do
        CreatesOrder.new(user).add_product_entry(product.id.to_s, "2")
        product.reload
      end.to change(product, :quantity).by(-2)
    end
  end
end
