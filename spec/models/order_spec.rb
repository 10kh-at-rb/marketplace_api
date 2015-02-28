require 'rails_helper'

RSpec.describe Order do
  subject { Fabricate.build(:order) }

  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:product_entries) }
  it { is_expected.to have_many(:products).through(:product_entries) }

  describe '#set_total!' do
    it "sets the total price of the order" do
      p1 = Fabricate(:product, price: 100)
      p2 = Fabricate(:product, price: 15)
      order = Fabricate(:order)
      order.product_entries.create(product: p1, quantity: 2)
      order.product_entries.create(product: p2, quantity: 3)

      order.set_total!

      expect(order.total).to eq(245)
    end
  end

  context "when there is not enough products left" do
    specify "the order is not valid" do
      order = Fabricate(:order)
      product = Fabricate(:product, price: 100, quantity: 5)
      product_entry = Fabricate(:product_entry,
                                product: product,
                                quantity: 6,
                                order: order)
      expect(order.reload).to_not be_valid
    end
  end
end
