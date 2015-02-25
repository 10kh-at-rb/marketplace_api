require 'rails_helper'

RSpec.describe Order do
  subject { Fabricate.build(:order) }

  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:products) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_and_belong_to_many(:products) }

  describe '#set_total!' do
    it "sets the total price of the order" do
      p1 = Fabricate(:product, price: 100)
      p2 = Fabricate(:product, price: 85)
      order = Fabricate(:order, products: [p1, p2])
      order.set_total!
      expect(order.total).to eq(185)
    end
  end
end
